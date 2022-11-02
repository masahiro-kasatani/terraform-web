<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.24.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb"></a> [alb](#module\_alb) | ../../modules/alb/ | n/a |
| <a name="module_ecs"></a> [ecs](#module\_ecs) | ../../modules/ecs/ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group_rule.ingress_container_port](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_http_port](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_subnet_ids"></a> [application\_subnet\_ids](#input\_application\_subnet\_ids) | APIコンテナを起動するサブネットのID | `list(string)` | n/a | yes |
| <a name="input_cf_hosted_zone_id"></a> [cf\_hosted\_zone\_id](#input\_cf\_hosted\_zone\_id) | CloudFrontホストゾーンID | `string` | n/a | yes |
| <a name="input_container_cpu"></a> [container\_cpu](#input\_container\_cpu) | コンテナCPUユニット数 | `number` | `256` | no |
| <a name="input_container_environments"></a> [container\_environments](#input\_container\_environments) | コンテナ環境変数 | <pre>list(object({<br>    Name  = string<br>    Value = string<br>  }))</pre> | `null` | no |
| <a name="input_container_image_uri"></a> [container\_image\_uri](#input\_container\_image\_uri) | コンテナイメージURI | `string` | n/a | yes |
| <a name="input_container_memory"></a> [container\_memory](#input\_container\_memory) | コンテナに適用されるメモリ量 | `number` | `512` | no |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | コンテナ名 | `string` | n/a | yes |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | コンテナポート | `number` | n/a | yes |
| <a name="input_container_secrets"></a> [container\_secrets](#input\_container\_secrets) | ECSコンテナSecret環境変数 | <pre>list(object({<br>    name      = string<br>    valueFrom = string<br>  }))</pre> | `null` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | ドメイン名 | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | システム環境 | `string` | n/a | yes |
| <a name="input_ephemeral_storage_size_gib"></a> [ephemeral\_storage\_size\_gib](#input\_ephemeral\_storage\_size\_gib) | ephemeralストレージサイズ（GiB） | `string` | `20` | no |
| <a name="input_hosted_zone_id"></a> [hosted\_zone\_id](#input\_hosted\_zone\_id) | ホストゾーンID | `string` | n/a | yes |
| <a name="input_lb_listener_blue"></a> [lb\_listener\_blue](#input\_lb\_listener\_blue) | リスナー(Blue)のパラメータ | <pre>object({<br>    name            = string<br>    http_port       = number<br>    https_port      = number<br>    certificate_arn = string<br>  })</pre> | n/a | yes |
| <a name="input_lb_listener_green"></a> [lb\_listener\_green](#input\_lb\_listener\_green) | リスナー(Green)のパラメータ | <pre>object({<br>    name            = string<br>    http_port       = number<br>    https_port      = number<br>    certificate_arn = string<br>  })</pre> | n/a | yes |
| <a name="input_lb_target_group_blue"></a> [lb\_target\_group\_blue](#input\_lb\_target\_group\_blue) | ターゲットグループ(Blue)のパラメータ | <pre>object({<br>    name                 = string<br>    target_type          = string<br>    port                 = number<br>    deregistration_delay = number<br>    health_check = object({<br>      matcher             = string<br>      healthy_threshold   = number<br>      unhealthy_threshold = number<br>      interval            = number<br>      timeout             = number<br>      path                = string<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_lb_target_group_green"></a> [lb\_target\_group\_green](#input\_lb\_target\_group\_green) | ターゲットグループ(Green)のパラメータ | <pre>object({<br>    name                 = string<br>    target_type          = string<br>    port                 = number<br>    deregistration_delay = number<br>    health_check = object({<br>      matcher             = string<br>      healthy_threshold   = number<br>      unhealthy_threshold = number<br>      interval            = number<br>      timeout             = number<br>      path                = string<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Name Prefix | `string` | n/a | yes |
| <a name="input_nat_gateway_ips"></a> [nat\_gateway\_ips](#input\_nat\_gateway\_ips) | NAT Gateway IPs | `list(string)` | n/a | yes |
| <a name="input_public_subnet_ids"></a> [public\_subnet\_ids](#input\_public\_subnet\_ids) | ロードバランサーを配置するサブネットのID | `list(string)` | n/a | yes |
| <a name="input_rds_secrets_arn"></a> [rds\_secrets\_arn](#input\_rds\_secrets\_arn) | RDS Credentials Secrets ARN | `string` | n/a | yes |
| <a name="input_task_cpu"></a> [task\_cpu](#input\_task\_cpu) | タスクCPUユニット数 | `number` | `256` | no |
| <a name="input_task_memory"></a> [task\_memory](#input\_task\_memory) | タスクに適用されるメモリ量 | `number` | `512` | no |
| <a name="input_vpc_endpoint_security_group_id"></a> [vpc\_endpoint\_security\_group\_id](#input\_vpc\_endpoint\_security\_group\_id) | VPC EndpointのSecurity Group ID | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | API構成をデプロイするVPCのID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecs_cluster_name"></a> [ecs\_cluster\_name](#output\_ecs\_cluster\_name) | ECSクラスタ名 |
| <a name="output_ecs_service_name"></a> [ecs\_service\_name](#output\_ecs\_service\_name) | ECSサービス名 |
| <a name="output_lb_dns_name"></a> [lb\_dns\_name](#output\_lb\_dns\_name) | ロードバランサーDNS名 |
| <a name="output_lb_https_listener_blue_arn"></a> [lb\_https\_listener\_blue\_arn](#output\_lb\_https\_listener\_blue\_arn) | ALBリスナーARN |
| <a name="output_lb_id"></a> [lb\_id](#output\_lb\_id) | ロードバランサーID |
| <a name="output_lb_target_group_blue_name"></a> [lb\_target\_group\_blue\_name](#output\_lb\_target\_group\_blue\_name) | ALBターゲットグループ（Blue） |
| <a name="output_lb_target_group_green_name"></a> [lb\_target\_group\_green\_name](#output\_lb\_target\_group\_green\_name) | ALBターゲットグループ（Green） |
<!-- END_TF_DOCS -->