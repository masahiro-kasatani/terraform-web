locals {
  create_policys_statements = var.attach_policys != null ? [for each in var.attach_policys : each if each != null] : null
}

######################
# ECS
######################

data "aws_region" "now" {}
data "aws_caller_identity" "self" {}

resource "aws_ecs_cluster" "main" {
  name = "${var.name_prefix}-${var.env}"
}

resource "aws_ecs_task_definition" "main" {
  family                   = "${var.name_prefix}-${var.env}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  task_role_arn            = aws_iam_role.ecs_task.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  cpu                      = var.task_cpu
  memory                   = var.task_memory_mb
  container_definitions = jsonencode([{
    name                   = var.container_name
    image                  = var.container_ecr_image_uri
    command                = var.container_command != null ? var.container_command : null
    cpu                    = var.container_cpu
    memory                 = var.container_memory_mb
    essential              = true
    readonlyRootFilesystem = var.readonly_root_filesystem
    mountPoints = var.volumes != null ? [for volume in var.volumes : {
      sourceVolume  = volume.name
      containerPath = volume.path
    }] : null

    portMappings = var.container_port != null ? [
      {
        containerPort = var.container_port
        hostPort      = var.container_port
      }
    ] : null

    environment = var.container_environments != null ? [for environment in var.container_environments :
      {
        name  = environment.Name
        value = environment.Value
      }
    ] : null

    secrets = var.container_secrets != null ? [
      for secret in var.container_secrets :
      {
        name      = secret.name
        valueFrom = secret.valueFrom
      }
    ] : null

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-stream-prefix : "ecs"
        awslogs-region : data.aws_region.now.name
        awslogs-group : aws_cloudwatch_log_group.main.name
      }
    }
  }])

  dynamic "ephemeral_storage" {
    for_each = var.ephemeral_storage_size_gib != null ? [var.ephemeral_storage_size_gib] : []

    content {
      size_in_gib = ephemeral_storage.value
    }
  }

  dynamic "volume" {
    for_each = var.volumes != null ? var.volumes : []

    content {
      name = volume.value.name
    }
  }
}

resource "aws_cloudwatch_log_group" "main" {
  name = "/ecs/${var.name_prefix}-${var.env}"
}

resource "aws_ecs_service" "main" {
  count = var.creates_ecs_service == true ? 1 : 0

  name                              = "${var.name_prefix}-${var.env}"
  launch_type                       = "FARGATE"
  cluster                           = aws_ecs_cluster.main.id
  task_definition                   = aws_ecs_task_definition.main.arn
  desired_count                     = var.service_desired_count
  health_check_grace_period_seconds = var.service_health_check_grace_period_seconds
  deployment_controller {
    type = var.service_deployment_controller_type
  }
  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }
  network_configuration {
    assign_public_ip = false
    subnets          = var.subnet_ids
    security_groups  = length(var.security_group_ids) != 0 ? concat(var.security_group_ids, [aws_security_group.default.id]) : [aws_security_group.default.id]
  }
  lifecycle {
    ignore_changes = [desired_count, task_definition, load_balancer]
  }
}

######################
# Security Group
######################
resource "aws_security_group" "default" {
  name   = "${var.name_prefix}-${var.env}"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    # tfsec:ignore:aws-vpc-no-public-egress-sgr
    cidr_blocks = ["0.0.0.0/0"] # ignored
  }
}

######################
# IAM
######################

# ECSタスク実行用IAMロールを作成
resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.name_prefix}-exec-${var.env}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com",
        }
      },
    ]
  })
}

# ECSタスクを実行するためのAWS管理ポリシーをECSタスク実行用IAMロールにアタッチ
resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECSタスク用のIAMロールを作成
resource "aws_iam_role" "ecs_task" {
  name = "${var.name_prefix}-task-${var.env}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com",
        }
      },
    ]
  })
}

# ECSタスク用のポリシー
data "aws_iam_policy_document" "ecs_task" {
  count = local.create_policys_statements != null ? 1 : 0

  dynamic "statement" {
    for_each = local.create_policys_statements

    content {
      sid         = try(statement.value.sid, null)
      effect      = try(statement.value.effect, null)
      actions     = try(statement.value.actions, null)
      not_actions = try(statement.value.not_actions, null)
      resources   = try(statement.value.resources, null)

      dynamic "principals" {
        for_each = statement.value.principals != null ? statement.value.principals : []

        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "not_principals" {
        for_each = statement.value.not_principals != null ? statement.value.not_principals : []

        content {
          type        = not_principals.value.type
          identifiers = not_principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = statement.value.condition != null ? statement.value.condition : []

        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

# ECSタスク用のIAMロールにアタッチ
resource "aws_iam_role_policy" "ecs_task" {
  count = local.create_policys_statements != null ? 1 : 0

  name   = "${var.name_prefix}-task-${var.env}"
  role   = aws_iam_role.ecs_task.name
  policy = data.aws_iam_policy_document.ecs_task[0].json
}

# 特定のSecrets ManagerへのGet権限ポリシーを作成
resource "aws_iam_policy" "get_secrets" {
  count = var.connect_to_rds == true ? 1 : 0

  name        = "${var.name_prefix}-exec-${var.env}"
  path        = "/"
  description = "GetSecretValue attached to TaskExecutionRole"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue",
        ]
        Effect   = "Allow"
        Resource = var.secrets_arn
      },
    ]
  })
}

# 特定のSecrets ManagerへのGet権限ポリシーをECSタスク実行用IAMロールにアタッチ
resource "aws_iam_role_policy_attachment" "get_secrets" {
  count = var.connect_to_rds == true ? 1 : 0

  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.get_secrets[0].arn
}
