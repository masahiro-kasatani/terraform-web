output "id" {
  description = "ロードバランサーID"
  value       = aws_lb.main.id
}
output "dns_name" {
  description = "ロードバランサーDNS名"
  value       = aws_lb.main.dns_name
}
output "zone_id" {
  description = "ロードバランサー ZONE ID"
  value       = aws_lb.main.zone_id
}
output "arn" {
  description = "ロードバランサー ARN"
  value       = aws_lb.main.arn
}
output "https_listener_blue_arn" {
  description = "ALBリスナーARN"
  value       = var.create_blue == true ? aws_lb_listener.https_blue[0].arn : null
}
output "target_group_blue_arn" {
  description = "ALBターゲットグループARN（Blue）"
  value       = var.create_blue == true ? aws_lb_target_group.blue[0].arn : null
}
output "target_group_green_arn" {
  description = "ALBターゲットグループARN（Green）"
  value       = var.create_green == true ? aws_lb_target_group.green[0].arn : null
}
output "target_group_blue_name" {
  description = "ALBターゲットグループ名（Blue）"
  value       = var.create_blue == true ? aws_lb_target_group.blue[0].name : null
}
output "target_group_green_name" {
  description = "ALBターゲットグループ名（Green）"
  value       = var.create_green == true ? aws_lb_target_group.green[0].name : null
}
output "security_group_id" {
  description = "ALBセキュリティグループ"
  value       = aws_security_group.alb.id
}