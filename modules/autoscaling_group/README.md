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
| [aws_autoscaling_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_iam_instance_profile.ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_launch_template.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_caller_identity.self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.now](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | Public IP設定 | `bool` | `false` | no |
| <a name="input_attach_policys"></a> [attach\_policys](#input\_attach\_policys) | StepFunctionsに適用するポリシー設定 | <pre>list(object({<br>    sid         = optional(string)<br>    effect      = string<br>    actions     = optional(list(string))<br>    not_actions = optional(list(string))<br>    resources   = list(string)<br>    principals = optional(list(object({<br>      type : string<br>      identifiers : list(string)<br>    })))<br>    not_principals = optional(list(object({<br>      type : string<br>      identifiers : list(string)<br>    })))<br>    condition = optional(list(object({<br>      test : string<br>      variable : string<br>      values : list(string)<br>    })))<br>  }))</pre> | `null` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | デフォルトの台数 | `number` | n/a | yes |
| <a name="input_ebs_configs"></a> [ebs\_configs](#input\_ebs\_configs) | EBSストレージ設定 | <pre>list(object({<br>    device_name    = string<br>    volume_size_gb = number<br>    volume_type    = string<br>  }))</pre> | `null` | no |
| <a name="input_env"></a> [env](#input\_env) | システム環境 | `string` | n/a | yes |
| <a name="input_image_id"></a> [image\_id](#input\_image\_id) | EC2インスタンスイメージID | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | EC2インスタンスタイプ | `string` | n/a | yes |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | 最大スケール幅 | `number` | n/a | yes |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | 最小スケール幅 | `number` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Name Prefix | `string` | n/a | yes |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Security Group IDs | `list(string)` | `null` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | 踏み台インスタンスを配置するサブネットのIDs | `list(string)` | n/a | yes |
| <a name="input_target_group_arns"></a> [target\_group\_arns](#input\_target\_group\_arns) | ELB Target Group ARNS | `list(string)` | `null` | no |
| <a name="input_user_data_base64"></a> [user\_data\_base64](#input\_user\_data\_base64) | User Data Scriptファイル（Base64） | `string` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->