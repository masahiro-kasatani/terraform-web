variable "name_prefix" {
  description = "Name Prefix"
  type        = string
}
variable "env" {
  type        = string
  description = "システム環境"
}
variable "subnet_ids" {
  type        = list(string)
  description = "踏み台インスタンスを配置するサブネットのIDs"
}
variable "desired_capacity" {
  type        = number
  description = "デフォルトの台数"
}
variable "max_size" {
  type        = number
  description = "最大スケール幅"
}
variable "min_size" {
  type        = number
  description = "最小スケール幅"
}
variable "image_id" {
  type        = string
  description = "EC2インスタンスイメージID"
}
variable "instance_type" {
  type        = string
  description = "EC2インスタンスタイプ"
}
variable "associate_public_ip_address" {
  type        = bool
  description = "Public IP設定"
  default     = false
}
variable "target_group_arns" {
  type        = list(string)
  description = "ELB Target Group ARNS"
  default     = null
}
variable "security_group_ids" {
  type        = list(string)
  description = "Security Group IDs"
  default     = null
}
variable "ebs_configs" {
  type = list(object({
    device_name    = string
    volume_size_gb = number
    volume_type    = string
  }))
  description = "EBSストレージ設定"
  default     = null
}
variable "user_data_base64" {
  type        = string
  description = "User Data Scriptファイル（Base64）"
  default     = null
}