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
# ECS
######################

variable "container_name" {
  type        = string
  description = "ECSコンテナ名"
}

variable "task_cpu" {
  type        = number
  description = "ECSタスクCPUユニット数"
}

variable "task_memory_mb" {
  type        = number
  description = "ECSタスクに適用されるメモリ量（MB）"
}

variable "container_ecr_image_uri" {
  type        = string
  description = "ECSコンテナイメージURI"
}

variable "container_command" {
  type        = list(string)
  description = "ECSコンテナに渡すコマンド"
  default     = null
}

variable "container_environments" {
  description = "ECSコンテナに渡す環境変数"
  type = list(object({
    Name  = string
    Value = string
  }))
  default = null
}

variable "container_port" {
  type        = number
  description = "ECSコンテナポート"
  default     = null
}

variable "container_cpu" {
  type        = number
  description = "ECSコンテナCPUユニット数"
}

variable "container_memory_mb" {
  type        = number
  description = "ECSコンテナに適用されるメモリ量（MB）"
}

variable "container_secrets" {
  type = list(object({
    name      = string
    valueFrom = string
  }))
  description = "ECSコンテナSecret環境変数"
  default     = null
}

variable "secrets_arn" {
  type        = string
  description = "ECSコンテナSecret ARN"
  default     = null
}

variable "vpc_id" {
  type        = string
  description = "ECS FargateのVPC ID"
}

variable "subnet_ids" {
  type        = list(string)
  description = "サブネットIDs"
  default     = []
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security Group IDs"
  default     = []
}

variable "creates_ecs_service" {
  type        = bool
  description = "ECS Service を作成する場合は true"
  default     = false
}

variable "connect_to_rds" {
  type        = bool
  description = "RDS に接続する場合は true"
  default     = true
}

variable "alb_target_group_arn" {
  type        = string
  description = "ALBターゲットグループARN"
  default     = null
}

variable "service_desired_count" {
  type        = number
  description = "ECS Service Desired Count"
  default     = 1
}

variable "service_health_check_grace_period_seconds" {
  type        = number
  description = "ECS Service Health Check Grace Period Seconds"
  default     = 300
}

variable "service_deployment_controller_type" {
  type        = string
  description = "ECS Service Default Controller Type"
  default     = "CODE_DEPLOY"
}

variable "readonly_root_filesystem" {
  type        = bool
  description = "READONLY ROOT FILESYSTEM"
  default     = true
}

variable "ephemeral_storage_size_gib" {
  type        = number
  description = "ephemeralストレージのサイズ設定（GiB）"
  default     = null
}

variable "volumes" {
  description = "ECSコンテナのVolume設定"
  type = list(object({
    name = string
    path = string
  }))
  default = null
}