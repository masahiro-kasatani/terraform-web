variable "name_prefix" {
  description = "Name Prefix"
  type        = string
}
variable "env" {
  type        = string
  description = "システム環境"
}
variable "hosted_zone_id" {
  type        = string
  description = "ホストゾーンID"
}
variable "domain_name" {
  type        = string
  description = "ドメイン名"
}
variable "lb_listener_blue" {
  description = "リスナー(Blue)のパラメータ"
  type = object({
    name            = string
    http_port       = number
    https_port      = number
    certificate_arn = string
  })
}
variable "lb_listener_green" {
  description = "リスナー(Green)のパラメータ"
  type = object({
    name            = string
    http_port       = number
    https_port      = number
    certificate_arn = string
  })
}
variable "lb_target_group_blue" {
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
}
variable "lb_target_group_green" {
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
}
variable "task_cpu" {
  type        = number
  description = "タスクCPUユニット数"
  default     = 256
}
variable "task_memory" {
  type        = number
  description = "タスクに適用されるメモリ量"
  default     = 512
}
variable "container_name" {
  type        = string
  description = "コンテナ名"
}
variable "container_image_uri" {
  type        = string
  description = "コンテナイメージURI"
}
variable "container_port" {
  type        = number
  description = "コンテナポート"
}
variable "container_cpu" {
  type        = number
  description = "コンテナCPUユニット数"
  default     = 256
}
variable "container_memory" {
  type        = number
  description = "コンテナに適用されるメモリ量"
  default     = 512
}
variable "container_secrets" {
  type = list(object({
    name      = string
    valueFrom = string
  }))
  description = "ECSコンテナSecret環境変数"
  default     = null
}
variable "container_environments" {
  type = list(object({
    Name  = string
    Value = string
  }))
  description = "コンテナ環境変数"
  default     = null
}
variable "ephemeral_storage_size_gib" {
  type        = string
  description = "ephemeralストレージサイズ（GiB）"
  default     = 20
}
variable "vpc_id" {
  type        = string
  description = "API構成をデプロイするVPCのID"
}
variable "public_subnet_ids" {
  type        = list(string)
  description = "ロードバランサーを配置するサブネットのID"
}
variable "application_subnet_ids" {
  type        = list(string)
  description = "APIコンテナを起動するサブネットのID"
}
variable "nat_gateway_ips" {
  type        = list(string)
  description = "NAT Gateway IPs"
}
variable "vpc_endpoint_security_group_id" {
  description = "VPC EndpointのSecurity Group ID"
  type        = string
}
variable "cf_hosted_zone_id" {
  type        = string
  description = "CloudFrontホストゾーンID"
}
variable "rds_secrets_arn" {
  type        = string
  description = "RDS Credentials Secrets ARN"
}
