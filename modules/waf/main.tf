locals {
  ip_list = [for ip in csvdecode(file(var.ipset_file_path)) : "${ip.IP_Address}"]
}
resource "aws_waf_ipset" "main" {
  name = "${var.name_prefix}-${var.env}"
  dynamic "ip_set_descriptors" {
    for_each = local.ip_list
    content {
      type  = "IPV4"
      value = ip_set_descriptors.value
    }
  }
}
resource "aws_waf_rule" "main" {
  name        = "${var.name_prefix}-${var.env}"
  metric_name = "Metric"
  predicates {
    negated = false
    data_id = aws_waf_ipset.main.id
    type    = "IPMatch"
  }
}
resource "aws_waf_web_acl" "main" {
  name        = "${var.name_prefix}-${var.env}"
  metric_name = "Metric"
  default_action {
    type = "BLOCK"
  }
  rules {
    priority = 0
    action {
      type = "ALLOW"
    }
    rule_id = aws_waf_rule.main.id
  }
}
