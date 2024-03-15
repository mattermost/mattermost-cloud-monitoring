## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.40.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.40.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.tgw_share_association_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.tgw_share_association_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_ram_resource_association.tgw_share_resource_association_prod](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_association) | resource |
| [aws_ram_resource_association.tgw_share_resource_association_test](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_association) | resource |
| [aws_ram_resource_share.tgw_share_prod](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share) | resource |
| [aws_ram_resource_share.tgw_share_test](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_enterprise_prod_tgw"></a> [cloud\_enterprise\_prod\_tgw](#input\_cloud\_enterprise\_prod\_tgw) | The Cloud enterprise prod Transit Gateway ID. | `string` | n/a | yes |
| <a name="input_cloud_enterprise_test_tgw"></a> [cloud\_enterprise\_test\_tgw](#input\_cloud\_enterprise\_test\_tgw) | The Cloud enterprise test Transit Gateway ID. | `string` | n/a | yes |
| <a name="input_prod_account_id"></a> [prod\_account\_id](#input\_prod\_account\_id) | The Cloud Prod account ID. | `string` | n/a | yes |
| <a name="input_share_name_prod"></a> [share\_name\_prod](#input\_share\_name\_prod) | The AWS share name to associate test Transit Gateways with. | `string` | n/a | yes |
| <a name="input_share_name_test"></a> [share\_name\_test](#input\_share\_name\_test) | The AWS share name to associate test Transit Gateways with. | `string` | n/a | yes |
| <a name="input_test_account_id"></a> [test\_account\_id](#input\_test\_account\_id) | The Cloud Test account ID. | `string` | n/a | yes |

## Outputs

No outputs.
