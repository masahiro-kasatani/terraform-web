locals {
  bastion_name = "${var.name_prefix}-${var.env}"
}

data "aws_region" "now" {}
data "aws_caller_identity" "self" {}

###########################################################################
# Autoscaling Group
###########################################################################
module "bastion" {
  source = "../../modules/autoscaling_group/"

  env              = var.env
  name_prefix      = var.name_prefix
  subnet_ids       = var.subnet_ids
  desired_capacity = 1
  max_size         = 1
  min_size         = 1
  image_id         = "ami-02c3627b04781eada"
  instance_type    = "t2.micro"
}

###########################################################################
# IAM
###########################################################################

# SSHアクセス用IAMポリシーの作成
data "aws_iam_policy_document" "ssh" {
  statement {
    effect  = "Allow"
    actions = ["ssm:StartSession"]
    resources = [
      "arn:aws:ec2:${data.aws_region.now.name}:${data.aws_caller_identity.self.account_id}:instance/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "ssm:resourceTag/Name"
      values   = [local.bastion_name]
    }
  }
  statement {
    effect    = "Allow"
    actions   = ["ssm:StartSession"]
    resources = ["arn:aws:ssm:*:*:document/AWS-StartSSHSession"]
  }
  statement {
    effect  = "Allow"
    actions = ["ec2-instance-connect:SendSSHPublicKey"]
    resources = [
      "arn:aws:ec2:${data.aws_region.now.name}:${data.aws_caller_identity.self.account_id}:instance/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "ec2:ResourceTag/Name"
      values   = [local.bastion_name]
    }
    condition {
      test     = "StringEquals"
      variable = "ec2:osuser"
      values   = [var.bastion_user]
    }
  }
  statement {
    effect    = "Allow"
    actions   = ["ec2:DescribeInstances"]
    resources = ["*"]
  }
}
# 踏み台接続用IAMグループの作成
# NOTE: コンソール画面にて、踏み台への接続を許可したいIAMユーザーを当該グループに追加する
resource "aws_iam_group" "bastion_users" {
  name = local.bastion_name
  path = "/users/"
}
# SSHアクセス用IAMポリシーを踏み台接続用IAMグループにアタッチ
resource "aws_iam_group_policy" "bastion_users" {
  name   = local.bastion_name
  group  = aws_iam_group.bastion_users.name
  policy = data.aws_iam_policy_document.ssh.json
}
