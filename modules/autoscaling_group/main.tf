locals {
  name                      = "${var.name_prefix}-${var.env}"
}

data "aws_region" "now" {}
data "aws_caller_identity" "self" {}

###########################################################################
# EC2
###########################################################################
resource "aws_autoscaling_group" "main" {
  name                = local.name
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = var.subnet_ids
  target_group_arns   = var.target_group_arns

  launch_template {
    id      = aws_launch_template.main.id
    version = aws_launch_template.main.latest_version
  }
}
resource "aws_launch_template" "main" {
  name                   = local.name
  image_id               = var.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = var.security_group_ids != null && var.associate_public_ip_address == false ? var.security_group_ids : null

  iam_instance_profile {
    name = aws_iam_instance_profile.ssm.name
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = local.name
    }
  }

  dynamic "network_interfaces" {
    for_each = var.associate_public_ip_address == true ? [true] : []
    content {
      associate_public_ip_address = var.associate_public_ip_address
      security_groups             = var.security_group_ids
    }
  }

  dynamic "block_device_mappings" {
    for_each = var.ebs_configs != null ? var.ebs_configs : []

    content {
      device_name = block_device_mappings.value.device_name

      ebs {
        volume_size           = block_device_mappings.value.volume_size_gb
        volume_type           = block_device_mappings.value.volume_type
        delete_on_termination = false
      }
    }
  }

  user_data = var.user_data_base64 != null ? var.user_data_base64 : null
}
resource "aws_iam_instance_profile" "ssm" {
  name = local.name
  role = aws_iam_role.ec2.name
}

###########################################################################
# IAM
###########################################################################

# EC2インスタンス用IAMロールを作成
resource "aws_iam_role" "ec2" {
  name = local.name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com",
        }
      },
    ]
  })
}

# SSM管理ポリシーをEC2インスタンス用IAMロールにアタッチ
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}