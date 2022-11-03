locals {
  engine         = var.engine == "mysql" ? "aurora-mysql" : var.engine == "postgresql" ? "aurora-postgresql" : null
  engine_version = var.engine == "mysql" ? "8.0.mysql_aurora.3.01.0" : var.engine == "postgresql" ? "13.6" : null
  port           = var.engine == "mysql" ? 3306 : var.engine == "postgresql" ? 5432 : null
  family         = var.engine == "mysql" ? "aurora-mysql8.0" : var.engine == "postgresql" ? "aurora-postgresql13" : null
  cluster_id     = "${var.name_prefix}-${var.env}"
}
data "aws_caller_identity" "self" {}

###########################################################################
# RDS Cluster
###########################################################################
resource "aws_rds_cluster" "main" {
  cluster_identifier = local.cluster_id

  engine         = local.engine
  engine_version = local.engine_version

  master_username = var.master_username
  master_password = random_password.master_password.result
  port            = local.port
  database_name   = var.default_schema

  availability_zones      = var.availability_zones
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window
  skip_final_snapshot     = var.skip_final_snapshot
  apply_immediately       = var.apply_immediately
  storage_encrypted       = true

  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.main.name
  db_subnet_group_name            = aws_db_subnet_group.main.name
  vpc_security_group_ids          = [aws_security_group.cluster.id]

  lifecycle {
    ignore_changes = [
      master_password,
      availability_zones,
      backup_retention_period
    ]
  }
}
resource "aws_rds_cluster_parameter_group" "main" {
  name   = local.cluster_id
  family = local.family

  dynamic "parameter" {
    for_each = var.rds_cluster_parameter_groups != null ? var.rds_cluster_parameter_groups : []

    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }
}
resource "aws_db_subnet_group" "main" {
  name       = local.cluster_id
  subnet_ids = var.subnet_ids
}

###########################################################################
# RDS Instance
###########################################################################
resource "aws_rds_cluster_instance" "main" {
  count = var.number_of_instances

  identifier     = "${var.name_prefix}-${count.index}-${var.env}"
  instance_class = var.instance_class

  publicly_accessible     = false
  monitoring_interval     = var.monitoring_interval
  monitoring_role_arn     = var.monitoring_interval != 0 ? aws_iam_role.rds_monitoring.arn : null
  cluster_identifier      = aws_rds_cluster.main.id
  engine                  = aws_rds_cluster.main.engine
  engine_version          = aws_rds_cluster.main.engine_version
  db_subnet_group_name    = aws_rds_cluster.main.db_subnet_group_name
  db_parameter_group_name = aws_db_parameter_group.main.name
}
resource "aws_db_parameter_group" "main" {
  name   = local.cluster_id
  family = local.family
}

###########################################################################
# Secrets Manager
###########################################################################
resource "aws_secretsmanager_secret" "rds_credentials" {
  name                    = local.cluster_id
  recovery_window_in_days = 0
}
resource "aws_secretsmanager_secret_version" "rds_credentials" {
  secret_id     = aws_secretsmanager_secret.rds_credentials.id
  secret_string = <<EOF
{
  "dbClusterIdentifier": "${aws_rds_cluster.main.cluster_identifier}",
  "engine": "${var.engine}",
  "host": "${aws_rds_cluster.main.endpoint}",
  "port": ${aws_rds_cluster.main.port},
  "dbname": "${aws_rds_cluster.main.database_name}",
  "username": "${aws_rds_cluster.main.master_username}",
  "password": "${random_password.master_password.result}"
}
EOF
}
resource "random_password" "master_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

###########################################################################
# Security Group
###########################################################################
resource "aws_security_group" "cluster" {
  name        = local.cluster_id
  description = "Attached to ${local.cluster_id}"
  vpc_id      = var.vpc_id
  ingress {
    description = "Only TCP from Application Subnets"
    from_port   = local.port
    to_port     = local.port
    protocol    = "tcp"
    cidr_blocks = var.application_subnet_cidrs
  }
  dynamic "ingress" {
    for_each = var.bastion_vpc_cidr != null ? [true] : []

    content {
      description = "Only TCP from Bastion VPC"
      from_port   = local.port
      to_port     = local.port
      protocol    = "tcp"
      cidr_blocks = [var.bastion_vpc_cidr]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    # tfsec:ignore:aws-vpc-no-public-egress-sgr
    cidr_blocks = ["0.0.0.0/0"] # ignored
  }
}

###########################################################################
# IAM
###########################################################################
data "aws_iam_policy_document" "rds_monitoring_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "rds_monitoring" {
  name               = local.cluster_id
  assume_role_policy = data.aws_iam_policy_document.rds_monitoring_policy.json
}
resource "aws_iam_role_policy_attachment" "rds_monitoring" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
  role       = aws_iam_role.rds_monitoring.name
}
