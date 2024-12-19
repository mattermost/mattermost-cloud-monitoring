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
| [aws_subnet.efs_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnet.nfs_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | AMI ID to use for the NFS server EC2 instance. | `string` | `"ami-0c55b159cbfafe1f0"` | no |
| <a name="input_detailed_monitoring"></a> [detailed\_monitoring](#input\_detailed\_monitoring) | If true, the detailed\_monitoring will be enabled. | `bool` | `true` | no |
| <a name="input_efs_encrypted"></a> [efs\_encrypted](#input\_efs\_encrypted) | If true, the disk will be encrypted. | `bool` | `true` | no |
| <a name="input_efs_kms_key_id"></a> [efs\_kms\_key\_id](#input\_efs\_kms\_key\_id) | Optional KMS Key ID for encrypting the EFS file system. Leave empty to use the default AWS-managed KMS key. | `string` | `""` | no |
| <a name="input_efs_performance_mode"></a> [efs\_performance\_mode](#input\_efs\_performance\_mode) | Performance mode for the EFS file system. | `string` | `"generalPurpose"` | no |
| <a name="input_efs_throughput_mode"></a> [efs\_throughput\_mode](#input\_efs\_throughput\_mode) | Throughput mode for the EFS file system. | `string` | `"bursting"` | no |
| <a name="input_enabled_efs"></a> [enabled\_efs](#input\_enabled\_efs) | Whether to create an EFS file system. | `bool` | `false` | no |
| <a name="input_enabled_nfs"></a> [enabled\_nfs](#input\_enabled\_nfs) | Whether to create an NFS server on EC2. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment for the deployment (e.g., dev, staging, prod). | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type for the NFS server. | `string` | `"t3.micro"` | no |
| <a name="input_nfs_encrypted"></a> [nfs\_encrypted](#input\_nfs\_encrypted) | If true, the EBS volume will be encrypted. | `bool` | `true` | no |
| <a name="input_nfs_kms_key_id"></a> [nfs\_kms\_key\_id](#input\_nfs\_kms\_key\_id) | Optional KMS Key ID for encrypting the NFS EBS storage. Leave empty to use the default AWS-managed KMS key. | `string` | `""` | no |
| <a name="input_nfs_storage_size"></a> [nfs\_storage\_size](#input\_nfs\_storage\_size) | The size of the EBS volume in GiB for the NFS server storage. | `number` | `50` | no |
| <a name="input_root_kms_key_id"></a> [root\_kms\_key\_id](#input\_root\_kms\_key\_id) | Optional KMS Key ID for encrypting the root volume of the NFS server. Leave empty to use the default AWS-managed KMS key. | `string` | `""` | no |
| <a name="input_root_volume_size"></a> [root\_volume\_size](#input\_root\_volume\_size) | Size of the root volume in GiB for the NFS server. | `number` | `20` | no |
| <a name="input_volume_type"></a> [volume\_type](#input\_volume\_type) | Type of volumefor the NFS server. | `string` | `"gp3"` | no |
| <a name="input_vpc_configurations"></a> [vpc\_configurations](#input\_vpc\_configurations) | Map of VPC configurations, including VPC ID and subnets. | <pre>map(object({<br>    vpc_id     = string<br>    subnet_ids = list(string)<br>  }))</pre> | n/a | yes |

## Outputs

No outputs.
