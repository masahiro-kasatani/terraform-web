output "rds_cluster_arn" {
  description = "RDS Cluster ARN"
  value       = aws_rds_cluster.main.arn
}
output "rds_cluster_id" {
  description = "RDS Cluster ID"
  value       = aws_rds_cluster.main.cluster_identifier
}
output "rds_secrets_arn" {
  description = "RDS Credentials Secrets ARN"
  value       = aws_secretsmanager_secret.rds_credentials.arn
}