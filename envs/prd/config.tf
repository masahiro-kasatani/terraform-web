provider "aws" {
  region = var.aws_region
  assume_role {
    role_arn = var.tf_role_arn
  }
  default_tags {
    tags = {
      "terraform:project" = var.project
      "terraform:env"     = var.env
      "terraform:author"  = "kasa"
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.22"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.3.2"
    }
  }
  backend "s3" {
    bucket  = "terraform-web"
    region  = "ap-northeast-1"
    key     = "envs/prd/terraform.tfstate"
    encrypt = true
  }
}