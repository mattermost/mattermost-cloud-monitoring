## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.41.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.41.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ebs_volume.nfs_storage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume) | resource |
| [aws_efs_file_system.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.efs_mount](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_instance.nfs_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_security_group.efs_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.nfs_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_volume_attachment.nfs_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/volume_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | AMI ID to use for the NFS server EC2 instance. | `string` | `"ami-0c55b159cbfafe1f0"` | no |
| <a name="input_deployment_name"></a> [deployment\_name](#input\_deployment\_name) | The name of the deployment for resource naming conventions. | `string` | n/a | yes |
| <a name="input_efs_performance_mode"></a> [efs\_performance\_mode](#input\_efs\_performance\_mode) | Performance mode for the EFS file system. | `string` | `"generalPurpose"` | no |
| <a name="input_efs_throughput_mode"></a> [efs\_throughput\_mode](#input\_efs\_throughput\_mode) | Throughput mode for the EFS file system. | `string` | `"bursting"` | no |
| <a name="input_enabled_efs"></a> [enabled\_efs](#input\_enabled\_efs) | Whether to create an EFS file system. | `bool` | `false` | no |
| <a name="input_enabled_nfs"></a> [enabled\_nfs](#input\_enabled\_nfs) | Whether to create an NFS server on EC2. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment for the deployment (e.g., dev, staging, prod). | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type for the NFS server. | `string` | `"t3.micro"` | no |
| <a name="input_nfs_security_group_ingress_cidr"></a> [nfs\_security\_group\_ingress\_cidr](#input\_nfs\_security\_group\_ingress\_cidr) | List of CIDR blocks allowed to access the NFS server. | `list(string)` | <pre>[<br>  "10.0.0.0/16"<br>]</pre> | no |
| <a name="input_nfs_storage_size"></a> [nfs\_storage\_size](#input\_nfs\_storage\_size) | The size of the EBS volume in GiB for the NFS server storage. | `number` | `50` | no |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | List of private subnet IDs where EFS mount targets or NFS server will reside. | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID for networking and security groups. | `string` | n/a | yes |

## Outputs

No outputs.
