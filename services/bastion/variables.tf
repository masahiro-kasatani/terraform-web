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
  description = "踏み台インスタンスを配置するサブネットのID"
}
variable "bastion_user" {
  type        = string
  description = "踏み台にアクセスするユーザー"
  default     = "ec2-user"
}