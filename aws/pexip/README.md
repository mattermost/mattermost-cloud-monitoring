## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.41.0 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | ~> 4.25.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.41.0 |
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | ~> 4.25.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.pexip_conference_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_eip.pexip_management_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_eip_association.pexip_conference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip_association) | resource |
| [aws_eip_association.pexip_management](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip_association) | resource |
| [aws_instance.pexip_conference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.pexip_management](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_network_interface.pexip_conference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |
| [aws_network_interface.pexip_management](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |
| [aws_security_group.pexip_conference_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.pexip_management_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [cloudflare_record.pexip_conference](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record) | resource |
| [cloudflare_record.pexip_management](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudflare_zone_id"></a> [cloudflare\_zone\_id](#input\_cloudflare\_zone\_id) | The Cloudflare zone ID provided | `string` | n/a | yes |
| <a name="input_conference_cloudflare_record_name"></a> [conference\_cloudflare\_record\_name](#input\_conference\_cloudflare\_record\_name) | The DNS name for the Pexip conference node | `string` | n/a | yes |
| <a name="input_conference_ec2_type"></a> [conference\_ec2\_type](#input\_conference\_ec2\_type) | The EC2 instance type for Pexip conference node | `string` | n/a | yes |
| <a name="input_conference_private_ips"></a> [conference\_private\_ips](#input\_conference\_private\_ips) | List of the private IPs of the Pexip Conference node | `list(string)` | n/a | yes |
| <a name="input_custom_conference_ec2_ami"></a> [custom\_conference\_ec2\_ami](#input\_custom\_conference\_ec2\_ami) | Customized with MM configuration Pexip AMI for conference node | `string` | n/a | yes |
| <a name="input_custom_management_ec2_ami"></a> [custom\_management\_ec2\_ami](#input\_custom\_management\_ec2\_ami) | Customized with MM configuration Pexip AMI for management node | `string` | n/a | yes |
| <a name="input_ec2_key_pair"></a> [ec2\_key\_pair](#input\_ec2\_key\_pair) | The key pair that will be used for ssh to EC2 instances of Pexip nodes | `string` | n/a | yes |
| <a name="input_initial_configuration"></a> [initial\_configuration](#input\_initial\_configuration) | A boolean variable to control the initial configuration of Pexip setup, when true official AMI will be deployed and key-pairs will be added to EC2 nodes | `bool` | `true` | no |
| <a name="input_management_cloudflare_record_name"></a> [management\_cloudflare\_record\_name](#input\_management\_cloudflare\_record\_name) | The DNS name for the Pexip management node | `string` | n/a | yes |
| <a name="input_management_ec2_type"></a> [management\_ec2\_type](#input\_management\_ec2\_type) | The EC2 instance type for Pexip management node | `string` | n/a | yes |
| <a name="input_management_private_ips"></a> [management\_private\_ips](#input\_management\_private\_ips) | List of the private IPs of the Pexip management node | `list(string)` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | `"pexip"` | no |
| <a name="input_official_pexip_conference_ec2_ami"></a> [official\_pexip\_conference\_ec2\_ami](#input\_official\_pexip\_conference\_ec2\_ami) | The official Pexip AMI for conference node | `string` | `"ami-0ddd16b36dc9f4229"` | no |
| <a name="input_official_pexip_management_ec2_ami"></a> [official\_pexip\_management\_ec2\_ami](#input\_official\_pexip\_management\_ec2\_ami) | The official Pexip AMI for management node | `string` | `"ami-0dd1e9ce5c9029446"` | no |
| <a name="input_public_subnet_id"></a> [public\_subnet\_id](#input\_public\_subnet\_id) | A public subnet ID | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the vpc for the security group of Pexip | `string` | n/a | yes |
| <a name="input_vpn_ips"></a> [vpn\_ips](#input\_vpn\_ips) | List of the IPs for the VPN | `list(string)` | n/a | yes |

## Outputs

No outputs.
