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
| [aws_autoscaling_group.calls_offloader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_key_pair.calls_offloader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_launch_template.calls_offloader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_lb.calls_offloader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.calls_offloader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.calls_offloader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_route53_record.calls_offloader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.calls_offloader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | AMI to use for the call offloader | `string` | n/a | yes |
| <a name="input_cloud_vpn_cidr"></a> [cloud\_vpn\_cidr](#input\_cloud\_vpn\_cidr) | The Cloud VPN CIDR for calls offloader access | `list(string)` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment which will deploy to and will be added as a tag | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type for the call offloader | `string` | `"c5.xlarge"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Minimum number of instances to run | `number` | `2` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Minimum number of instances to run | `number` | `1` | no |
| <a name="input_private_hosted_zoneid"></a> [private\_hosted\_zoneid](#input\_private\_hosted\_zoneid) | Private Hosted Zone ID for the VPC | `string` | n/a | yes |
| <a name="input_public_key"></a> [public\_key](#input\_public\_key) | Public key to use for the call offloader | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List Subnet ID to use for the call offloader ASG | `list(string)` | n/a | yes |
| <a name="input_teleport_cidr"></a> [teleport\_cidr](#input\_teleport\_cidr) | The Teleport CIDR for calls offloader access | `list(string)` | n/a | yes |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | The VPC CIDR for calls offloader access and load balancer access | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID to use for the call offloader | `string` | n/a | yes |
| <a name="input_vpc_worker_sg_id"></a> [vpc\_worker\_sg\_id](#input\_vpc\_worker\_sg\_id) | Security Group ID for the worker nodes in the VPC | `list(string)` | n/a | yes |

## Outputs

No outputs.
