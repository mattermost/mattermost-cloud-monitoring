<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_destination_cidr_block"></a> [destination\_cidr\_block](#input\_destination\_cidr\_block) | The destination CIDR block | `string` | n/a | yes |
| <a name="input_route_table_ids"></a> [route\_table\_ids](#input\_route\_table\_ids) | The ID of the routing tables | `list(string)` | n/a | yes |
| <a name="input_timeout_create"></a> [timeout\_create](#input\_timeout\_create) | The destination CIDR block | `string` | `"5m"` | no |
| <a name="input_transit_gateway_id"></a> [transit\_gateway\_id](#input\_transit\_gateway\_id) | The ID of an EC2 Transit Gateway | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_this_destination_cidr_block"></a> [this\_destination\_cidr\_block](#output\_this\_destination\_cidr\_block) | The destination CIDR block |
| <a name="output_this_route_table_ids"></a> [this\_route\_table\_ids](#output\_this\_route\_table\_ids) | The ID of the routing tables |
| <a name="output_this_transit_gateway_id"></a> [this\_transit\_gateway\_id](#output\_this\_transit\_gateway\_id) | The ID of an EC2 Transit Gateway |
<!-- END_TF_DOCS -->