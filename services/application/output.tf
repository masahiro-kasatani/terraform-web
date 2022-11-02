output "lb_id" {
  description = "ロードバランサーID"
  value       = module.alb.id
}
output "lb_dns_name" {
  description = "ロードバランサーDNS名"
  value       = module.alb.dns_name
}
output "lb_https_listener_blue_arn" {
  description = "ALBリスナーARN"
  value       = module.alb.https_listener_blue_arn
}
output "lb_target_group_blue_name" {
  description = "ALBターゲットグループ（Blue）"
  value       = module.alb.target_group_blue_name
}
output "lb_target_group_green_name" {
  description = "ALBターゲットグループ（Green）"
  value       = module.alb.target_group_green_name
}
output "ecs_cluster_name" {
  description = "ECSクラスタ名"
  value       = module.ecs.ecs_cluster_name
}
output "ecs_service_name" {
  description = "ECSサービス名"
  value       = module.ecs.ecs_service_name
}