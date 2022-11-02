######################
# Common
######################

variable "tf_role_arn" {
  description = "terraformを実行するロールARN"
  type        = string
}

variable "aws_region" {
  description = "AWSリージョン"
  type        = string
}

variable "project" {
  description = "プロジェクト名"
  type        = string
}

variable "env" {
  description = "環境名"
  type        = string
}
