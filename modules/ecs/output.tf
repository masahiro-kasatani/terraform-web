output "cluster_arn" {
  description = "ECS Clusterの ARN"
  value       = aws_ecs_cluster.main.arn
}

output "ecs_cluster_name" {
  description = "ECSクラスタ名"
  value       = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  description = "ECSサービス名"
  value       = join("", aws_ecs_service.main.*.name)
}

output "security_group_id" {
  description = "ECS Task DefinitionのSecurity Group ID"
  value       = aws_security_group.default.id
}

output "task_definition_arn" {
  description = "ECS Task Definitionの ARN"
  value       = aws_ecs_task_definition.main.arn
}

output "task_excution_role_arn" {
  description = "ECSタスクの実行ロールARN"
  value       = aws_iam_role.ecs_task_execution.arn
}

output "task_role_arn" {
  description = "ECSタスクのロールARN"
  value       = aws_iam_role.ecs_task.arn
}

output "task_role_name" {
  description = "ECSタスクのロール名"
  value       = aws_iam_role.ecs_task.name
}