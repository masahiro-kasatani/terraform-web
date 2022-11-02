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
| [aws_cloudwatch_log_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_cluster.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_policy.get_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.ecs_task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ecs_task_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.ecs_task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.ecs_task_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.get_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_caller_identity.self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.ecs_task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.now](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_target_group_arn"></a> [alb\_target\_group\_arn](#input\_alb\_target\_group\_arn) | ALBターゲットグループARN | `string` | `null` | no |
| <a name="input_attach_policys"></a> [attach\_policys](#input\_attach\_policys) | ECSタスクに適用するポリシー設定 | <pre>list(object({<br>    sid         = optional(string)<br>    effect      = string<br>    actions     = optional(list(string))<br>    not_actions = optional(list(string))<br>    resources   = list(string)<br>    principals = optional(list(object({<br>      type : string<br>      identifiers : list(string)<br>    })))<br>    not_principals = optional(list(object({<br>      type : string<br>      identifiers : list(string)<br>    })))<br>    condition = optional(list(object({<br>      test : string<br>      variable : string<br>      values : list(string)<br>    })))<br>  }))</pre> | `null` | no |
| <a name="input_connect_to_rds"></a> [connect\_to\_rds](#input\_connect\_to\_rds) | RDS に接続する場合は true | `bool` | `true` | no |
| <a name="input_container_command"></a> [container\_command](#input\_container\_command) | ECSコンテナに渡すコマンド | `list(string)` | `null` | no |
| <a name="input_container_cpu"></a> [container\_cpu](#input\_container\_cpu) | ECSコンテナCPUユニット数 | `number` | n/a | yes |
| <a name="input_container_ecr_image_uri"></a> [container\_ecr\_image\_uri](#input\_container\_ecr\_image\_uri) | ECSコンテナイメージURI | `string` | n/a | yes |
| <a name="input_container_environments"></a> [container\_environments](#input\_container\_environments) | ECSコンテナに渡す環境変数 | <pre>list(object({<br>    Name  = string<br>    Value = string<br>  }))</pre> | `null` | no |
| <a name="input_container_memory_mb"></a> [container\_memory\_mb](#input\_container\_memory\_mb) | ECSコンテナに適用されるメモリ量（MB） | `number` | n/a | yes |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | ECSコンテナ名 | `string` | n/a | yes |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | ECSコンテナポート | `number` | `null` | no |
| <a name="input_container_secrets"></a> [container\_secrets](#input\_container\_secrets) | ECSコンテナSecret環境変数 | <pre>list(object({<br>    name      = string<br>    valueFrom = string<br>  }))</pre> | `null` | no |
| <a name="input_creates_ecs_service"></a> [creates\_ecs\_service](#input\_creates\_ecs\_service) | ECS Service を作成する場合は true | `bool` | `false` | no |
| <a name="input_env"></a> [env](#input\_env) | 環境名 | `string` | n/a | yes |
| <a name="input_ephemeral_storage_size_gib"></a> [ephemeral\_storage\_size\_gib](#input\_ephemeral\_storage\_size\_gib) | ephemeralストレージのサイズ設定（GiB） | `number` | `null` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Name Prefix | `string` | n/a | yes |
| <a name="input_readonly_root_filesystem"></a> [readonly\_root\_filesystem](#input\_readonly\_root\_filesystem) | READONLY ROOT FILESYSTEM | `bool` | `true` | no |
| <a name="input_secrets_arn"></a> [secrets\_arn](#input\_secrets\_arn) | ECSコンテナSecret ARN | `string` | `null` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Security Group IDs | `list(string)` | `[]` | no |
| <a name="input_service_deployment_controller_type"></a> [service\_deployment\_controller\_type](#input\_service\_deployment\_controller\_type) | ECS Service Default Controller Type | `string` | `"CODE_DEPLOY"` | no |
| <a name="input_service_desired_count"></a> [service\_desired\_count](#input\_service\_desired\_count) | ECS Service Desired Count | `number` | `1` | no |
| <a name="input_service_health_check_grace_period_seconds"></a> [service\_health\_check\_grace\_period\_seconds](#input\_service\_health\_check\_grace\_period\_seconds) | ECS Service Health Check Grace Period Seconds | `number` | `300` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | サブネットIDs | `list(string)` | `[]` | no |
| <a name="input_task_cpu"></a> [task\_cpu](#input\_task\_cpu) | ECSタスクCPUユニット数 | `number` | n/a | yes |
| <a name="input_task_memory_mb"></a> [task\_memory\_mb](#input\_task\_memory\_mb) | ECSタスクに適用されるメモリ量（MB） | `number` | n/a | yes |
| <a name="input_volumes"></a> [volumes](#input\_volumes) | ECSコンテナのVolume設定 | <pre>list(object({<br>    name = string<br>    path = string<br>  }))</pre> | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ECS FargateのVPC ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | ECS Clusterの ARN |
| <a name="output_ecs_cluster_name"></a> [ecs\_cluster\_name](#output\_ecs\_cluster\_name) | ECSクラスタ名 |
| <a name="output_ecs_service_name"></a> [ecs\_service\_name](#output\_ecs\_service\_name) | ECSサービス名 |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | ECS Task DefinitionのSecurity Group ID |
| <a name="output_task_definition_arn"></a> [task\_definition\_arn](#output\_task\_definition\_arn) | ECS Task Definitionの ARN |
| <a name="output_task_excution_role_arn"></a> [task\_excution\_role\_arn](#output\_task\_excution\_role\_arn) | ECSタスクの実行ロールARN |
| <a name="output_task_role_arn"></a> [task\_role\_arn](#output\_task\_role\_arn) | ECSタスクのロールARN |
| <a name="output_task_role_name"></a> [task\_role\_name](#output\_task\_role\_name) | ECSタスクのロール名 |
<!-- END_TF_DOCS -->