variable "env" {
  type        = string
  description = "システム環境"
}
variable "name_prefix" {
  description = "Name Prefix"
  type        = string
}
variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
}
variable "public_subnets" {
  type        = list(map(string))
  description = "Public サブネット"
}
variable "private_subnets" {
  type        = list(map(string))
  description = "Private サブネット（NAT Gateway へのルーティングあり）"
}
variable "database_subnets" {
  type        = list(map(string))
  description = "Private サブネット（NAT Gateway へのルーティングなし）"
}
