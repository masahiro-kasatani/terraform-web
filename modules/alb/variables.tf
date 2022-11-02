######################
# Common
######################

variable "env" {
  description = "環境名"
  type        = string
}

variable "name_prefix" {
  description = "Name Prefix"
  type        = string
}

######################
# ALB
######################

variable "create_blue" {
  description = "リスナー(Blue)の作成"
  type        = bool
  default     = true
}

variable "listener_blue" {
  description = "リスナー(Blue)のパラメータ"
  type = object({
    name            = string
    http_port       = number
    https_port      = number
    certificate_arn = string
  })
  default = null
}

variable "target_group_blue" {
  description = "ターゲットグループ(Blue)のパラメータ"
  type = object({
    name                 = string
    target_type          = string
    port                 = number
    deregistration_delay = number
    health_check = object({
      matcher             = string
      healthy_threshold   = number
      unhealthy_threshold = number
      interval            = number
      timeout             = number
      path                = string
    })
  })
  default = null
}

variable "create_green" {
  description = "リスナー(Green)の作成"
  type        = bool
  default     = true
}

variable "listener_green" {
  description = "リスナー(Green)のパラメータ"
  type = object({
    name            = string
    http_port       = number
    https_port      = number
    certificate_arn = string
  })
  default = null
}

variable "target_group_green" {
  description = "ターゲットグループ(Green)のパラメータ"
  type = object({
    name                 = string
    target_type          = string
    port                 = number
    deregistration_delay = number
    health_check = object({
      matcher             = string
      healthy_threshold   = number
      unhealthy_threshold = number
      interval            = number
      timeout             = number
      path                = string
    })
  })
  default = null
}

######################
# Container
######################

variable "container_port" {
  type        = number
  description = "コンテナポート"
}

######################
# VPC
######################

variable "vpc_id" {
  type        = string
  description = "ロードバランサーを配置するVPCのID"
}
variable "subnet_ids" {
  type        = list(string)
  description = "ロードバランサーを配置するサブネットのID"
}
