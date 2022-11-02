<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.24.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_origin_config"></a> [alb\_origin\_config](#input\_alb\_origin\_config) | ALBオリジン設定 | <pre>list(object({<br>    origin_id   = string<br>    domain_name = string<br>    custom_origin_config = object({<br>      http_port : number<br>      https_port : number<br>      origin_read_timeout : number<br>      origin_keepalive_timeout : number<br>    })<br>  }))</pre> | `null` | no |
| <a name="input_aliases"></a> [aliases](#input\_aliases) | エイリアス | `list(string)` | n/a | yes |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | Certificate ARN（us-east-1） | `string` | n/a | yes |
| <a name="input_default_cache_behavior"></a> [default\_cache\_behavior](#input\_default\_cache\_behavior) | デフォルトのキャシュ設定 | <pre>object({<br>    allowed_methods  = list(string)<br>    cached_methods   = list(string)<br>    target_origin_id = string<br>    min_ttl          = number<br>    default_ttl      = number<br>    max_ttl          = number<br><br>    lambda_function_association = optional(list(object({<br>      event_type   = string<br>      lambda_arn   = string<br>      include_body = bool<br>    })))<br><br>    forwarded_values = object({<br>      query_string    = bool<br>      cookies_forward = string<br>      headers         = list(string)<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | システム環境 | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Name Prefix | `string` | n/a | yes |
| <a name="input_ordered_cache_behavior"></a> [ordered\_cache\_behavior](#input\_ordered\_cache\_behavior) | 優先度のキャッシュ動作 | <pre>list(object({<br>    path_pattern     = string<br>    allowed_methods  = list(string)<br>    cached_methods   = list(string)<br>    target_origin_id = string<br>    min_ttl          = number<br>    default_ttl      = number<br>    max_ttl          = number<br><br>    forwarded_values = object({<br>      query_string    = bool<br>      cookies_forward = string<br>      headers         = list(string)<br>    })<br>  }))</pre> | `null` | no |
| <a name="input_s3_origin_config"></a> [s3\_origin\_config](#input\_s3\_origin\_config) | S3バケットオリジン設定 | <pre>list(object({<br>    origin_id              = string<br>    domain_name            = string<br>    origin_access_identity = string<br>  }))</pre> | `null` | no |
| <a name="input_web_acl_id"></a> [web\_acl\_id](#input\_web\_acl\_id) | Web ACL ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_domain_name"></a> [domain\_name](#output\_domain\_name) | ドメイン名 |
| <a name="output_hosted_zone_id"></a> [hosted\_zone\_id](#output\_hosted\_zone\_id) | ホストゾーンID |
<!-- END_TF_DOCS -->