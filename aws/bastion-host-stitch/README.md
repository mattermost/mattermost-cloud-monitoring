<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.12 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.bastion_ip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_instance.bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.stitch-blapi](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_security_group.connect-ec2-rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.stitch-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | n/a | `string` | n/a | yes |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | n/a | `bool` | `true` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | n/a | `string` | `"us-east-1a"` | no |
| <a name="input_connect_rds_ec2_security_group"></a> [connect\_rds\_ec2\_security\_group](#input\_connect\_rds\_ec2\_security\_group) | n/a | `string` | n/a | yes |
| <a name="input_cpu_credits"></a> [cpu\_credits](#input\_cpu\_credits) | n/a | `string` | `"unlimited"` | no |
| <a name="input_delete_on_termination"></a> [delete\_on\_termination](#input\_delete\_on\_termination) | n/a | `bool` | `true` | no |
| <a name="input_disable_api_termination"></a> [disable\_api\_termination](#input\_disable\_api\_termination) | n/a | `bool` | `true` | no |
| <a name="input_ebs_optimized"></a> [ebs\_optimized](#input\_ebs\_optimized) | If true, the launched EC2 instance will be EBS-optimized | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment will be created | `string` | n/a | yes |
| <a name="input_filepath"></a> [filepath](#input\_filepath) | n/a | `string` | `"."` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type of the ec2 instance | `string` | `"t3.micro"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | n/a | `string` | n/a | yes |
| <a name="input_monitoring"></a> [monitoring](#input\_monitoring) | n/a | `bool` | `false` | no |
| <a name="input_public_key"></a> [public\_key](#input\_public\_key) | n/a | `string` | n/a | yes |
| <a name="input_source_dest_check"></a> [source\_dest\_check](#input\_source\_dest\_check) | n/a | `bool` | `true` | no |
| <a name="input_stitch_ips"></a> [stitch\_ips](#input\_stitch\_ips) | n/a | `list(string)` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | n/a | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resource | `map(string)` | `{}` | no |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | n/a | `number` | `20` | no |
| <a name="input_volume_type"></a> [volume\_type](#input\_volume\_type) | n/a | `string` | `"gp3"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID of the database cluster | `string` | n/a | yes |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | The IDs of the security groups that will be assigned to the node | `list(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
