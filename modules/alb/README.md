<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.25.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_lb.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.http_blue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.http_green](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.https_blue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.https_green](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.blue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.green](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_security_group.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | コンテナポート | `number` | n/a | yes |
| <a name="input_create_blue"></a> [create\_blue](#input\_create\_blue) | リスナー(Blue)の作成 | `bool` | `true` | no |
| <a name="input_create_green"></a> [create\_green](#input\_create\_green) | リスナー(Green)の作成 | `bool` | `true` | no |
| <a name="input_env"></a> [env](#input\_env) | 環境名 | `string` | n/a | yes |
| <a name="input_listener_blue"></a> [listener\_blue](#input\_listener\_blue) | リスナー(Blue)のパラメータ | <pre>object({<br>    name            = string<br>    http_port       = number<br>    https_port      = number<br>    certificate_arn = string<br>  })</pre> | `null` | no |
| <a name="input_listener_green"></a> [listener\_green](#input\_listener\_green) | リスナー(Green)のパラメータ | <pre>object({<br>    name            = string<br>    http_port       = number<br>    https_port      = number<br>    certificate_arn = string<br>  })</pre> | `null` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Name Prefix | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | ロードバランサーを配置するサブネットのID | `list(string)` | n/a | yes |
| <a name="input_target_group_blue"></a> [target\_group\_blue](#input\_target\_group\_blue) | ターゲットグループ(Blue)のパラメータ | <pre>object({<br>    name                 = string<br>    target_type          = string<br>    port                 = number<br>    deregistration_delay = number<br>    health_check = object({<br>      matcher             = string<br>      healthy_threshold   = number<br>      unhealthy_threshold = number<br>      interval            = number<br>      timeout             = number<br>      path                = string<br>    })<br>  })</pre> | `null` | no |
| <a name="input_target_group_green"></a> [target\_group\_green](#input\_target\_group\_green) | ターゲットグループ(Green)のパラメータ | <pre>object({<br>    name                 = string<br>    target_type          = string<br>    port                 = number<br>    deregistration_delay = number<br>    health_check = object({<br>      matcher             = string<br>      healthy_threshold   = number<br>      unhealthy_threshold = number<br>      interval            = number<br>      timeout             = number<br>      path                = string<br>    })<br>  })</pre> | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ロードバランサーを配置するVPCのID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ロードバランサー ARN |
| <a name="output_dns_name"></a> [dns\_name](#output\_dns\_name) | ロードバランサーDNS名 |
| <a name="output_https_listener_blue_arn"></a> [https\_listener\_blue\_arn](#output\_https\_listener\_blue\_arn) | ALBリスナーARN |
| <a name="output_id"></a> [id](#output\_id) | ロードバランサーID |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | ALBセキュリティグループ |
| <a name="output_target_group_blue_arn"></a> [target\_group\_blue\_arn](#output\_target\_group\_blue\_arn) | ALBターゲットグループARN（Blue） |
| <a name="output_target_group_blue_name"></a> [target\_group\_blue\_name](#output\_target\_group\_blue\_name) | ALBターゲットグループ名（Blue） |
| <a name="output_target_group_green_arn"></a> [target\_group\_green\_arn](#output\_target\_group\_green\_arn) | ALBターゲットグループARN（Green） |
| <a name="output_target_group_green_name"></a> [target\_group\_green\_name](#output\_target\_group\_green\_name) | ALBターゲットグループ名（Green） |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | ロードバランサー ZONE ID |
<!-- END_TF_DOCS -->