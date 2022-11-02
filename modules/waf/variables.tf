variable "env" {
  type        = string
  description = "システム環境"
}
variable "name_prefix" {
  description = "Name Prefix"
  type        = string
}
variable "ipset_file_path" {
  description = "ipsetファイルパス設定"
  type        = string
}