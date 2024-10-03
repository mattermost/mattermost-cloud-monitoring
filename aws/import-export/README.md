## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.41.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.41.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_kms_alias.s3_kms_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.customer_managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.buckets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.buckets_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.buckets_sse](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kms_key_description"></a> [kms\_key\_description](#input\_kms\_key\_description) | Description for the customer managed KMS key | `string` | `"Customer managed KMS key for S3 buckets"` | no |
| <a name="input_other_account_id"></a> [other\_account\_id](#input\_other\_account\_id) | AWS Account ID that needs access to the KMS key | `string` | n/a | yes |
| <a name="input_other_account_role_name"></a> [other\_account\_role\_name](#input\_other\_account\_role\_name) | Role name in the other AWS account that needs access to the KMS key | `string` | n/a | yes |
| <a name="input_other_account_user_name"></a> [other\_account\_user\_name](#input\_other\_account\_user\_name) | User name in the other AWS account that needs access to the KMS key | `string` | n/a | yes |
| <a name="input_s3_bucket_policies"></a> [s3\_bucket\_policies](#input\_s3\_bucket\_policies) | Map of bucket names to their respective policies | `map(string)` | `{}` | no |
| <a name="input_s3_buckets"></a> [s3\_buckets](#input\_s3\_buckets) | List of S3 buckets to manage | `list(string)` | `[]` | no |

## Outputs

No outputs.
