
## Overview
This module can be used to provision aws resources required by the community application.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.55 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.55.0 |
| <a name="provider_aws.destination"></a> [aws.destination](#provider\_aws.destination) | 4.55.0 |
| <a name="provider_aws.source"></a> [aws.source](#provider\_aws.source) | 4.55.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_bucket.mattermost-cloud-provisioning-dest-bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.bucket_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_replication_configuration.source_to_dest](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_replication_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.encrypting-provisioning-bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.provisioning-bucket-versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_kms_key.master_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |
| [aws_s3_bucket.source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_distination_bucket_enabled"></a> [create\_distination\_bucket\_enabled](#input\_create\_distination\_bucket\_enabled) | Create Distination bucket if sets to true, otherwise use existing bucket | `bool` | `false` | no |
| <a name="input_deployment_name"></a> [deployment\_name](#input\_deployment\_name) | The name of the deployment | `string` | `"test-replication"` | no |
| <a name="input_destination_region"></a> [destination\_region](#input\_destination\_region) | The name of the destination bucket region | `string` | n/a | yes |
| <a name="input_destination_s3_kms_key"></a> [destination\_s3\_kms\_key](#input\_destination\_s3\_kms\_key) | The destination SSE KMS key to encrypt/decrypt the bucket data | `string` | n/a | yes |
| <a name="input_s3_cross_region_replication_enabled"></a> [s3\_cross\_region\_replication\_enabled](#input\_s3\_cross\_region\_replication\_enabled) | Cross region replication flag for the bucket | `bool` | `true` | no |
| <a name="input_source_bucket"></a> [source\_bucket](#input\_source\_bucket) | The Name of the source bucket for cross region replication | `string` | n/a | yes |
| <a name="input_source_region"></a> [source\_region](#input\_source\_region) | The name of the source bucket region | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for bucket & cost calculation | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The vpc id which host the cluster & access the bucket | `string` | `"vpc-0d912fae7e7d01a52"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
