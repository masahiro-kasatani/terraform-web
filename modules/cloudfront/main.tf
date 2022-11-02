###########################################################################
# CloudFront
###########################################################################

resource "aws_cloudfront_distribution" "main" {
  aliases         = var.aliases
  enabled         = true
  is_ipv6_enabled = false
  web_acl_id      = var.web_acl_id

  dynamic "origin" {
    for_each = var.s3_origin_config != null ? var.s3_origin_config : []

    content {
      origin_id   = origin.value.origin_id
      domain_name = origin.value.domain_name

      s3_origin_config {
        origin_access_identity = origin.value.origin_access_identity
      }
    }
  }

  dynamic "origin" {
    for_each = var.alb_origin_config != null ? var.alb_origin_config : []

    content {
      origin_id   = origin.value.origin_id
      domain_name = origin.value.domain_name

      custom_origin_config {
        http_port                = origin.value.custom_origin_config.http_port
        https_port               = origin.value.custom_origin_config.https_port
        origin_protocol_policy   = "https-only"
        origin_ssl_protocols     = ["TLSv1", "TLSv1.1", "TLSv1.2"]
        origin_read_timeout      = origin.value.custom_origin_config.origin_read_timeout
        origin_keepalive_timeout = origin.value.custom_origin_config.origin_keepalive_timeout
      }
    }
  }

  viewer_certificate {
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
    cloudfront_default_certificate = false
    acm_certificate_arn            = var.certificate_arn
  }

  default_cache_behavior {
    allowed_methods        = var.default_cache_behavior.allowed_methods
    cached_methods         = var.default_cache_behavior.cached_methods
    target_origin_id       = var.default_cache_behavior.target_origin_id
    min_ttl                = var.default_cache_behavior.min_ttl
    default_ttl            = var.default_cache_behavior.default_ttl
    max_ttl                = var.default_cache_behavior.max_ttl
    compress               = true
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = var.default_cache_behavior.forwarded_values.query_string
      cookies {
        forward = var.default_cache_behavior.forwarded_values.cookies_forward
      }
      headers = var.default_cache_behavior.forwarded_values.headers
    }

    dynamic "lambda_function_association" {
      for_each = var.default_cache_behavior.lambda_function_association != null ? var.default_cache_behavior.lambda_function_association : []

      content {
        event_type   = lambda_function_association.value.event_type
        lambda_arn   = lambda_function_association.value.lambda_arn
        include_body = lambda_function_association.value.include_body
      }
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.ordered_cache_behavior != null ? var.ordered_cache_behavior : []

    content {
      path_pattern           = ordered_cache_behavior.value.path_pattern
      allowed_methods        = ordered_cache_behavior.value.allowed_methods
      cached_methods         = ordered_cache_behavior.value.cached_methods
      target_origin_id       = ordered_cache_behavior.value.target_origin_id
      min_ttl                = ordered_cache_behavior.value.min_ttl
      default_ttl            = ordered_cache_behavior.value.default_ttl
      max_ttl                = ordered_cache_behavior.value.max_ttl
      viewer_protocol_policy = "redirect-to-https"

      forwarded_values {
        query_string = ordered_cache_behavior.value.forwarded_values.query_string
        cookies {
          forward = ordered_cache_behavior.value.forwarded_values.cookies_forward
        }
        headers = ordered_cache_behavior.value.forwarded_values.headers
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "${var.name_prefix}-${var.env}"
  }
}