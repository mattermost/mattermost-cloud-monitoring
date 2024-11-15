## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.69.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.69.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway_vpc_attachment.tgw_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_route.private_tgw_attachment_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public_tgw_attachment_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_private_route_table_ids"></a> [private\_route\_table\_ids](#input\_private\_route\_table\_ids) | n/a | `list(string)` | n/a | yes |
| <a name="input_private_tgw_routes"></a> [private\_tgw\_routes](#input\_private\_tgw\_routes) | n/a | `list(string)` | n/a | yes |
| <a name="input_public_route_table_ids"></a> [public\_route\_table\_ids](#input\_public\_route\_table\_ids) | n/a | `list(string)` | n/a | yes |
| <a name="input_public_tgw_routes"></a> [public\_tgw\_routes](#input\_public\_tgw\_routes) | n/a | `list(string)` | n/a | yes |
| <a name="input_security_group_referencing_support"></a> [security\_group\_referencing\_support](#input\_security\_group\_referencing\_support) | Security Group Referencing allows to specify other SGs as references, or matching criterion in inbound security rules to allow instance-to-instance traffic | `string` | `"enable"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | n/a | `list(string)` | n/a | yes |
| <a name="input_transit_gateway_id"></a> [transit\_gateway\_id](#input\_transit\_gateway\_id) | n/a | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
