## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.55 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.55 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.call_offloader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_security_group.calls_offloader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | AMI to use for the call offloader | `string` | n/a | yes |
| <a name="input_cloud_vpn_cidr"></a> [cloud\_vpn\_cidr](#input\_cloud\_vpn\_cidr) | The Cloud VPN CIDR for calls offloader access | `list(string)` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type for the call offloader | `string` | `"c5.2xlarge"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Subnet ID to use for the call offloader | `string` | n/a | yes |
| <a name="input_teleport_cidr"></a> [teleport\_cidr](#input\_teleport\_cidr) | The Teleport CIDR for calls offloader access | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID to use for the call offloader | `string` | n/a | yes |
| <a name="input_vpc_worker_sg_id"></a> [vpc\_worker\_sg\_id](#input\_vpc\_worker\_sg\_id) | Security Group ID for the worker nodes in the VPC | `list(string)` | n/a | yes |

## Outputs

No outputs.
