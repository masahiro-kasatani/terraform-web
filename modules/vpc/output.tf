output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}
output "public_subnet_ids" {
  description = "Public Subnet IDs"
  value       = [for value in aws_subnet.public : value.id]
}
output "application_subnet_ids" {
  description = "Application Subnet IDs"
  value       = [for value in aws_subnet.private_app : value.id]
}
output "database_subnet_ids" {
  description = "Database Subnet IDs"
  value       = [for value in aws_subnet.private_db : value.id]
}
output "private_route_table_ids" {
  description = "Private Route Table IDs"
  value       = [for value in aws_route_table.private : value.id]
}
output "vpc_endpoint_security_group_id" {
  description = "VPC Endpointに通信可能なSecurity Group ID"
  value       = aws_security_group.allow_from_vpc_endpoint.id
}
output "s3_vpc_endpoint_id" {
  description = "S3 VPC Endpoint ID"
  value       = aws_vpc_endpoint.s3.id
}
output "sqs_vpc_endpoint_id" {
  description = "SQS VPC Endpoint ID"
  value       = aws_vpc_endpoint.sqs.id
}
output "nat_gateway_ips" {
  description = "NAT Gateway IPs"
  value       = [for value in aws_eip.nat_gateway : value.public_ip]
}