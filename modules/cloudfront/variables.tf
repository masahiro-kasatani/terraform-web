variable "env" {
  type        = string
  description = "システム環境"
}

variable "name_prefix" {
  description = "Name Prefix"
  type        = string
}

variable "aliases" {
  type        = list(string)
  description = "エイリアス"
}

variable "certificate_arn" {
  type        = string
  description = "Certificate ARN（us-east-1）"
}

variable "web_acl_id" {
  type        = string
  description = "Web ACL ID"
}

variable "s3_origin_config" {
  description = "S3バケットオリジン設定"
  type = list(object({
    origin_id              = string
    domain_name            = string
    origin_access_identity = string
  }))
  default = null
}

variable "alb_origin_config" {
  description = "ALBオリジン設定"
  type = list(object({
    origin_id   = string
    domain_name = string
    custom_origin_config = object({
      http_port : number
      https_port : number
      origin_read_timeout : number
      origin_keepalive_timeout : number
    })
  }))
  default = null
}

variable "default_cache_behavior" {
  description = "デフォルトのキャシュ設定"
  type = object({
    allowed_methods  = list(string)
    cached_methods   = list(string)
    target_origin_id = string
    min_ttl          = number
    default_ttl      = number
    max_ttl          = number

    lambda_function_association = optional(list(object({
      event_type   = string
      lambda_arn   = string
      include_body = bool
    })))

    forwarded_values = object({
      query_string    = bool
      cookies_forward = string
      headers         = list(string)
    })
  })
}

variable "ordered_cache_behavior" {
  description = "優先度のキャッシュ動作"
  type = list(object({
    path_pattern     = string
    allowed_methods  = list(string)
    cached_methods   = list(string)
    target_origin_id = string
    min_ttl          = number
    default_ttl      = number
    max_ttl          = number

    forwarded_values = object({
      query_string    = bool
      cookies_forward = string
      headers         = list(string)
    })
  }))
  default = null
}