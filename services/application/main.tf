locals {
  dns_split    = split(".", var.domain_name)
  record_name  = local.dns_split[0]
  service_name = "${var.name_prefix}-${var.env}"
}

###########################################################################
# Route 53
###########################################################################
resource "aws_route53_record" "main" {
  type    = "A"
  name    = local.record_name
  zone_id = var.hosted_zone_id
  alias {
    evaluate_target_health = false
    name                   = module.alb.dns_name
    zone_id                = module.alb.zone_id
  }
}

###########################################################################
# ALB
###########################################################################
module "alb" {
  source             = "../../modules/alb/"
  env                = var.env
  name_prefix        = var.name_prefix
  vpc_id             = var.vpc_id
  subnet_ids         = var.public_subnet_ids
  listener_blue      = var.lb_listener_blue
  listener_green     = var.lb_listener_green
  target_group_blue  = var.lb_target_group_blue
  target_group_green = var.lb_target_group_green
  container_port     = var.container_port
}

###########################################################################
# ECS
###########################################################################
module "ecs" {
  source                  = "../../modules/ecs/"
  env                     = var.env
  name_prefix             = var.name_prefix
  container_name          = var.container_name
  container_port          = var.container_port
  task_cpu                = var.task_cpu
  task_memory_mb          = var.task_memory
  container_cpu           = var.container_cpu
  container_memory_mb     = var.container_memory
  container_ecr_image_uri = var.container_image_uri
  container_environments  = var.container_environments
  container_secrets = [
    {
      "name" : "DB_HOST"
      "valueFrom" : "${var.rds_secrets_arn}:host::"
    },
    {
      "name" : "DB_PORT"
      "valueFrom" : "${var.rds_secrets_arn}:port::"
    },
    {
      "name" : "DB_NAME"
      "valueFrom" : "${var.rds_secrets_arn}:dbname::"
    },
    {
      "name" : "DB_USERNAME"
      "valueFrom" : "${var.rds_secrets_arn}:username::"
    },
    {
      "name" : "DB_PASSWORD"
      "valueFrom" : "${var.rds_secrets_arn}:password::"
    }
  ]
  creates_ecs_service        = true
  alb_target_group_arn       = module.alb.target_group_blue_arn
  vpc_id                     = var.vpc_id
  subnet_ids                 = var.application_subnet_ids
  security_group_ids         = [var.vpc_endpoint_security_group_id]
  secrets_arn                = var.rds_secrets_arn
  ephemeral_storage_size_gib = var.ephemeral_storage_size_gib
  volumes = [
    {
      name = "tmp"
      path = "/tmp"
    }
  ]
  depends_on = [module.alb]
}

###########################################################################
# Security Group
###########################################################################

resource "aws_security_group_rule" "ingress_http_port" {
  type                     = "ingress"
  from_port                = "80"
  to_port                  = "80"
  protocol                 = "tcp"
  security_group_id        = module.ecs.security_group_id
  source_security_group_id = module.alb.security_group_id
}

resource "aws_security_group_rule" "ingress_container_port" {
  type                     = "ingress"
  from_port                = var.container_port
  to_port                  = var.container_port
  protocol                 = "tcp"
  security_group_id        = module.ecs.security_group_id
  source_security_group_id = module.alb.security_group_id
}
