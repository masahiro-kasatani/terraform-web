output "web_acl_id" {
  description = "Web ACL ID"
  value       = aws_waf_web_acl.main.id
}