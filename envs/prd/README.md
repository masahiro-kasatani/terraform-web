<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.22 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.3.2 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_application"></a> [application](#module\_application) | ../../services/application/ | n/a |
| <a name="module_bastion"></a> [bastion](#module\_bastion) | ../../services/bastion/ | n/a |
| <a name="module_bastion_vpc"></a> [bastion\_vpc](#module\_bastion\_vpc) | ../../modules/vpc/ | n/a |
| <a name="module_cloudfront"></a> [cloudfront](#module\_cloudfront) | ../../modules/cloudfront/ | n/a |
| <a name="module_database"></a> [database](#module\_database) | ../../services/database/ | n/a |
| <a name="module_peering"></a> [peering](#module\_peering) | ../../modules/peering/ | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ../../modules/vpc/ | n/a |
| <a name="module_waf"></a> [waf](#module\_waf) | ../../modules/waf/ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWSリージョン | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | 環境名 | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | プロジェクト名 | `string` | n/a | yes |
| <a name="input_tf_role_arn"></a> [tf\_role\_arn](#input\_tf\_role\_arn) | terraformを実行するロールARN | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->