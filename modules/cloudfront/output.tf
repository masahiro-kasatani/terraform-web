output "domain_name" {
  description = "ドメイン名"
  value       = aws_cloudfront_distribution.main.domain_name
}
output "hosted_zone_id" {
  description = "ホストゾーンID"
  value       = aws_cloudfront_distribution.main.hosted_zone_id
}