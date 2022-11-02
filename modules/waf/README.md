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
| [aws_waf_ipset.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/waf_ipset) | resource |
| [aws_waf_rule.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/waf_rule) | resource |
| [aws_waf_web_acl.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/waf_web_acl) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | システム環境 | `string` | n/a | yes |
| <a name="input_ipset_file_path"></a> [ipset\_file\_path](#input\_ipset\_file\_path) | ipsetファイルパス設定 | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Name Prefix | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_web_acl_id"></a> [web\_acl\_id](#output\_web\_acl\_id) | Web ACL ID |
<!-- END_TF_DOCS -->