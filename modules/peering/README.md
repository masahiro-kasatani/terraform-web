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
| [aws_main_route_table_association.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/main_route_table_association) | resource |
| [aws_main_route_table_association.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/main_route_table_association) | resource |
| [aws_route.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.accepter_main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.requester_main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_vpc_peering_connection.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accepter_route_table_ids"></a> [accepter\_route\_table\_ids](#input\_accepter\_route\_table\_ids) | アクセプタルートテーブルIDs | `list(string)` | n/a | yes |
| <a name="input_accepter_subnet_cidrs"></a> [accepter\_subnet\_cidrs](#input\_accepter\_subnet\_cidrs) | アクセプタサブネットCIDRs | `list(string)` | n/a | yes |
| <a name="input_accepter_subnet_ids"></a> [accepter\_subnet\_ids](#input\_accepter\_subnet\_ids) | アクセプタサブネットIDs | `list(string)` | n/a | yes |
| <a name="input_accepter_vpc_cidr"></a> [accepter\_vpc\_cidr](#input\_accepter\_vpc\_cidr) | アクセプタVPC CIDR | `string` | n/a | yes |
| <a name="input_accepter_vpc_id"></a> [accepter\_vpc\_id](#input\_accepter\_vpc\_id) | アクセプタVPC ID | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | システム環境 | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Name Prefix | `string` | n/a | yes |
| <a name="input_requester_route_table_ids"></a> [requester\_route\_table\_ids](#input\_requester\_route\_table\_ids) | リクエスタルートテーブルIDs | `list(string)` | n/a | yes |
| <a name="input_requester_subnet_cidrs"></a> [requester\_subnet\_cidrs](#input\_requester\_subnet\_cidrs) | リクエスタサブネットCIDRs | `list(string)` | n/a | yes |
| <a name="input_requester_subnet_ids"></a> [requester\_subnet\_ids](#input\_requester\_subnet\_ids) | リクエスタサブネットIDs | `list(string)` | n/a | yes |
| <a name="input_requester_vpc_cidr"></a> [requester\_vpc\_cidr](#input\_requester\_vpc\_cidr) | リクエスタVPC CIDR | `string` | n/a | yes |
| <a name="input_requester_vpc_id"></a> [requester\_vpc\_id](#input\_requester\_vpc\_id) | リクエスタVPC ID | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->