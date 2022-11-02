locals {
  availability_zones = ["ap-northeast-1a", "ap-northeast-1c"]
  vpc_cidr           = "10.0.0.0/16"
  public_subnets = {
    name  = "public"
    cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  }
  private_subnets = {
    name  = "application"
    cidrs = ["10.0.64.0/24", "10.0.65.0/24"]
  }
  database_subnets = {
    name  = "database"
    cidrs = ["10.0.128.0/24", "10.0.129.0/24"]
  }
  bastion_vpc_cidr = "10.1.0.0/16"
  bastion_public_subnets = {
    name  = "public"
    cidrs = ["10.1.1.0/24"]
  }
  bastion_private_subnets = {
    name  = "private"
    cidrs = ["10.1.64.0/24"]
  }
}

###########################################################################
# Network
###########################################################################
module "vpc" {
  source      = "../../modules/vpc/"
  env         = var.env
  name_prefix = var.project
  vpc_cidr    = local.vpc_cidr
  public_subnets = [
    {
      az   = local.availability_zones[0]
      name = local.public_subnets.name
      cidr = local.public_subnets.cidrs[0]
    },
    {
      az   = local.availability_zones[1]
      name = local.public_subnets.name
      cidr = local.public_subnets.cidrs[1]
    },
  ]
  private_subnets = [
    {
      az   = local.availability_zones[0]
      name = local.private_subnets.name
      cidr = local.private_subnets.cidrs[0]
    },
    {
      az   = local.availability_zones[1]
      name = local.private_subnets.name
      cidr = local.private_subnets.cidrs[1]
    },
  ]
  database_subnets = [
    {
      az   = local.availability_zones[0]
      name = local.database_subnets.name
      cidr = local.database_subnets.cidrs[0]
    },
    {
      az   = local.availability_zones[1]
      name = local.database_subnets.name
      cidr = local.database_subnets.cidrs[1]
    },
  ]
}

module "bastion_vpc" {
  source      = "../../modules/vpc/"
  env         = var.env
  name_prefix = "${var.project}-bastion"
  vpc_cidr    = local.bastion_vpc_cidr
  public_subnets = [
    {
      az   = local.availability_zones[0]
      name = local.bastion_public_subnets.name
      cidr = local.bastion_public_subnets.cidrs[0]
    }
  ]
  private_subnets = [
    {
      az   = local.availability_zones[0]
      name = local.bastion_private_subnets.name
      cidr = local.bastion_private_subnets.cidrs[0]
    }
  ]
  database_subnets = []
}

module "peering" {
  source                    = "../../modules/peering/"
  name_prefix               = var.project
  env                       = var.env
  accepter_vpc_id           = module.vpc.vpc_id
  accepter_vpc_cidr         = local.vpc_cidr
  accepter_subnet_ids       = module.vpc.application_subnet_ids
  accepter_subnet_cidrs     = local.private_subnets.cidrs
  accepter_route_table_ids  = module.vpc.private_route_table_ids
  requester_vpc_id          = module.bastion_vpc.vpc_id
  requester_vpc_cidr        = local.bastion_vpc_cidr
  requester_subnet_ids      = module.bastion_vpc.application_subnet_ids
  requester_subnet_cidrs    = local.bastion_private_subnets.cidrs
  requester_route_table_ids = module.bastion_vpc.private_route_table_ids
}

###########################################################################
# WAF
###########################################################################
module "waf" {
  source      = "../../modules/waf/"
  name_prefix = var.project
  env         = var.env
  ipset_file_path = "${path.module}/ipset/waf_white_list.csv"
}

###########################################################################
# CloudFront
###########################################################################
module "cloudfront" {
  source = "../../modules/cloudfront/"

  name_prefix = var.project
  env         = var.env

  aliases         = ["hoge.jp"]
  certificate_arn = "arn:aws:acm:us-east-1:111111111111:certificate/xxxxxxxxxx"
  web_acl_id      = module.waf.web_acl_id

  alb_origin_config = [
    {
      origin_id   = module.application.lb_id
      domain_name = module.application.lb_dns_name
      custom_origin_config = {
        http_port                = 80
        https_port               = 443
        origin_read_timeout      = 60
        origin_keepalive_timeout = 5
      }
    },
  ]

  default_cache_behavior = {
    allowed_methods  = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
    cached_methods   = ["HEAD", "GET", "OPTIONS"]
    min_ttl          = 0
    default_ttl      = 0
    max_ttl          = 0
    target_origin_id = module.application.lb_id

    forwarded_values = {
      query_string    = true
      headers         = ["*"]
      cookies_forward = "all"
    }
  }
}

###########################################################################
# Application
###########################################################################
module "application" {
  source         = "../../services/application/"
  name_prefix    = var.project
  env            = var.env
  hosted_zone_id = "xxxxxxxxxx"
  domain_name    = "hoge.jp"
  lb_listener_blue = {
    name            = "blue"
    http_port       = 80
    https_port      = 443
    certificate_arn = "arn:aws:acm:ap-northeast-1:111111111111:certificate/xxxxxxxxxx"
  }
  lb_listener_green = {
    name            = "green"
    http_port       = 10080
    https_port      = 8443
    certificate_arn = "arn:aws:acm:ap-northeast-1:812194919787:certificate/ef757fa5-c719-4cd1-8e8d-33f8a192492b"
  }
  lb_target_group_blue = {
    name                 = "blue"
    target_type          = "ip"
    port                 = 8080
    deregistration_delay = 120
    health_check = {
      matcher             = "200-299"
      healthy_threshold   = 5
      unhealthy_threshold = 2
      interval            = 30
      timeout             = 5
      path                = "/healthcheck"
    }
  }
  lb_target_group_green = {
    name                 = "green"
    target_type          = "ip"
    port                 = 10080
    deregistration_delay = 120
    health_check = {
      matcher             = "200-299"
      healthy_threshold   = 5
      unhealthy_threshold = 2
      interval            = 30
      timeout             = 5
      path                = "/healthcheck"
    }
  }
  container_name      = "app"
  container_image_uri = "111111111111.dkr.ecr.ap-northeast-1.amazonaws.com/app:latest"
  container_port      = 8080
  container_environments = [
    {
      Name  = "HOGE"
      Value = "hoge"
    }
  ]
  ephemeral_storage_size_gib     = 30
  vpc_id                         = module.vpc.vpc_id
  public_subnet_ids              = module.vpc.public_subnet_ids
  application_subnet_ids         = module.vpc.application_subnet_ids
  vpc_endpoint_security_group_id = module.vpc.vpc_endpoint_security_group_id
  nat_gateway_ips                = module.vpc.nat_gateway_ips
  cf_hosted_zone_id              = module.cloudfront.hosted_zone_id
  rds_secrets_arn                = module.database.rds_secrets_arn
}

###########################################################################
# Database
###########################################################################
module "database" {
  source                   = "../../services/database/"
  name_prefix              = var.project
  env                      = var.env
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.database_subnet_ids
  application_subnet_cidrs = local.private_subnets.cidrs
  bastion_vpc_cidr         = local.bastion_vpc_cidr
  rds_cluster_parameter_groups = [
    {
      name         = "time_zone"
      value        = "Asia/Tokyo"
      apply_method = "pending-reboot"
    },
    {
      name         = "character_set_client"
      value        = "utf8mb4"
      apply_method = "immediate"
    },
    {
      name         = "character_set_connection"
      value        = "utf8mb4"
      apply_method = "immediate"
    },
    {
      name         = "character_set_database"
      value        = "utf8mb4"
      apply_method = "immediate"
    },
    {
      name         = "character_set_results"
      value        = "utf8mb4"
      apply_method = "immediate"
    },
    {
      name         = "character_set_server"
      value        = "utf8mb4"
      apply_method = "immediate"
    },
    {
      name         = "collation_server"
      value        = "utf8mb4_general_ci"
      apply_method = "pending-reboot"
    },
    {
      name         = "innodb_file_per_table"
      value        = "1"
      apply_method = "pending-reboot"
    },
    {
      name         = "skip-character-set-client-handshake"
      value        = "1"
      apply_method = "pending-reboot"
    }
  ]
}

###########################################################################
# Bastion
###########################################################################
module "bastion" {
  source      = "../../services/bastion/"
  name_prefix = "${var.project}-bastion"
  env         = var.env
  subnet_ids  = module.bastion_vpc.application_subnet_ids
}
