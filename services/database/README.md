<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.24.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.3.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_parameter_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group) | resource |
| [aws_db_subnet_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_iam_role.rds_monitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.rds_monitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_rds_cluster.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster_instance.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) | resource |
| [aws_rds_cluster_parameter_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_parameter_group) | resource |
| [aws_secretsmanager_secret.rds_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.rds_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [random_password.master_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_caller_identity.self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.rds_monitoring_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_subnet_cidrs"></a> [application\_subnet\_cidrs](#input\_application\_subnet\_cidrs) | DBへのアクセスを許可するアプリケーションが属するサブネットのID | `list(string)` | n/a | yes |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | インスタンスへの設定変更の即時反映設定。trueにすると即時で行われ、falseにすると次回のメンテナスウィンドウで行われる。 | `bool` | `true` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | アベイラビリティゾーン | `list(string)` | <pre>[<br>  "ap-northeast-1a",<br>  "ap-northeast-1c"<br>]</pre> | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | バックアップを保持する日数（リードレプリカを使用する場合は 0よりも大きい値を設定する：0〜35） | `number` | `0` | no |
| <a name="input_bastion_vpc_cidr"></a> [bastion\_vpc\_cidr](#input\_bastion\_vpc\_cidr) | DBへのアクセスを許可する踏み台インスタンスが属するサブネットのID | `string` | `null` | no |
| <a name="input_default_schema"></a> [default\_schema](#input\_default\_schema) | デフォルトのスキーマ名 | `string` | `"springdb"` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | 利用するRDSエンジン | `string` | `"mysql"` | no |
| <a name="input_env"></a> [env](#input\_env) | システム環境 | `string` | n/a | yes |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | DBインスタンスクラス | `string` | `"db.t4g.medium"` | no |
| <a name="input_master_username"></a> [master\_username](#input\_master\_username) | マスターユーザー名 | `string` | `"admin"` | no |
| <a name="input_monitoring_interval"></a> [monitoring\_interval](#input\_monitoring\_interval) | 拡張モニタリングの間隔（1、5、10、15、30、60、0はOFF） | `number` | `0` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Name Prefix | `string` | n/a | yes |
| <a name="input_number_of_instances"></a> [number\_of\_instances](#input\_number\_of\_instances) | DBインスタンス数 | `number` | `1` | no |
| <a name="input_preferred_backup_window"></a> [preferred\_backup\_window](#input\_preferred\_backup\_window) | 日次の自動バックアップウィンドウ（例：10:00-10:30） | `string` | `null` | no |
| <a name="input_rds_cluster_parameter_groups"></a> [rds\_cluster\_parameter\_groups](#input\_rds\_cluster\_parameter\_groups) | RDSクラスタのパラメータグループ設定<br>※参照<br>https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_parameter_group#parameter" | <pre>list(object({<br>    name         = string<br>    value        = string<br>    apply_method = string<br>  }))</pre> | `null` | no |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | クラスター削除時にスナップショットを取得するかどうか | `bool` | `true` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | RDSインスタンスを配置するサブネットのID | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | RDSクラスタを配置するVPCのID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rds_cluster_arn"></a> [rds\_cluster\_arn](#output\_rds\_cluster\_arn) | RDS Cluster ARN |
| <a name="output_rds_cluster_id"></a> [rds\_cluster\_id](#output\_rds\_cluster\_id) | RDS Cluster ID |
| <a name="output_rds_secrets_arn"></a> [rds\_secrets\_arn](#output\_rds\_secrets\_arn) | RDS Credentials Secrets ARN |
<!-- END_TF_DOCS -->