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
| [aws_ec2_transit_gateway.mattermost-cloud-tgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway) | resource |
| [aws_ec2_transit_gateway_peering_attachment.use1_usw2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_peering_attachment) | resource |
| [aws_ec2_transit_gateway_route.cloud](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_route.security](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_vpc_attachment.external](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_ram_principal_association.ram-principal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_principal_association) | resource |
| [aws_ram_resource_association.ram-tgw-association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_association) | resource |
| [aws_ram_resource_share.tgw-share](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_amazon_side_asn"></a> [amazon\_side\_asn](#input\_amazon\_side\_asn) | The Autonomous System Number (ASN) for the Amazon side of the gateway. By default the TGW is created with the current default Amazon ASN. | `string` | `"64512"` | no |
| <a name="input_cloud_destination_cidr_block"></a> [cloud\_destination\_cidr\_block](#input\_cloud\_destination\_cidr\_block) | Value of the cidr block for the cloud core TGW | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description of the EC2 Transit Gateway | `string` | `null` | no |
| <a name="input_enable_auto_accept_shared_attachments"></a> [enable\_auto\_accept\_shared\_attachments](#input\_enable\_auto\_accept\_shared\_attachments) | Whether resource attachment requests are automatically accepted | `string` | `"enable"` | no |
| <a name="input_enable_default_route_table_association"></a> [enable\_default\_route\_table\_association](#input\_enable\_default\_route\_table\_association) | Whether resource attachments are automatically associated with the default association route table | `string` | `"enable"` | no |
| <a name="input_enable_default_route_table_propagation"></a> [enable\_default\_route\_table\_propagation](#input\_enable\_default\_route\_table\_propagation) | Whether resource attachments automatically propagate routes to the default propagation route table | `string` | `"enable"` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Should be true to enable DNS support in the TGW | `string` | `"enable"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to be used on all the resources as identifier | `string` | `""` | no |
| <a name="input_peer_account_id"></a> [peer\_account\_id](#input\_peer\_account\_id) | The account ID of the peer account | `string` | n/a | yes |
| <a name="input_peer_region"></a> [peer\_region](#input\_peer\_region) | The region we want to peer with (us-east-1) | `string` | n/a | yes |
| <a name="input_peer_transit_gateway_id"></a> [peer\_transit\_gateway\_id](#input\_peer\_transit\_gateway\_id) | The ID for the TGW in us-east-1 that we want to peer with | `string` | n/a | yes |
| <a name="input_ram_allow_external_principals"></a> [ram\_allow\_external\_principals](#input\_ram\_allow\_external\_principals) | Indicates whether principals outside your organization can be associated with a resource share. | `bool` | `true` | no |
| <a name="input_ram_name"></a> [ram\_name](#input\_ram\_name) | The name of the resource share of TGW | `string` | `""` | no |
| <a name="input_ram_principals"></a> [ram\_principals](#input\_ram\_principals) | A list of principals to share TGW with. Possible values are an AWS account ID, an AWS Organizations Organization ARN, or an AWS Organizations Organization Unit ARN | `list(string)` | `[]` | no |
| <a name="input_ram_tags"></a> [ram\_tags](#input\_ram\_tags) | Additional tags for the RAM | `map(string)` | `{}` | no |
| <a name="input_security_destination_cidr_block"></a> [security\_destination\_cidr\_block](#input\_security\_destination\_cidr\_block) | Value of the cidr block for the security TGW | `string` | n/a | yes |
| <a name="input_security_group_referencing_support"></a> [security\_group\_referencing\_support](#input\_security\_group\_referencing\_support) | Security Group Referencing allows to specify other SGs as references, or matching criterion in inbound security rules to allow instance-to-instance traffic | `string` | `"enable"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags for the RAM | `map(string)` | `{}` | no |
| <a name="input_tgw_attachment_subnet_ids"></a> [tgw\_attachment\_subnet\_ids](#input\_tgw\_attachment\_subnet\_ids) | The Subnet IDs in the prod us-west-2 region we want to attach to the TGW | `list(string)` | <pre>[<br/>  ""<br/>]</pre> | no |
| <a name="input_tgw_attachment_vpc_id"></a> [tgw\_attachment\_vpc\_id](#input\_tgw\_attachment\_vpc\_id) | The VPC in the cross region we want to attach to the TGW | `string` | n/a | yes |
| <a name="input_tgw_peering_attachment_name"></a> [tgw\_peering\_attachment\_name](#input\_tgw\_peering\_attachment\_name) | The name of the peering attachment | `string` | n/a | yes |

## Outputs

No outputs.
