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
| [aws_iam_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_user.user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy_attachment.attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_s3_bucket_object.customer_folder](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | The AWS account ID which will be used. | `string` | n/a | yes |
| <a name="input_bucket"></a> [bucket](#input\_bucket) | The S3 bucket where the binary is located | `string` | n/a | yes |
| <a name="input_customer_bucket_folder"></a> [customer\_bucket\_folder](#input\_customer\_bucket\_folder) | The S3 bucket folder where the binary is located | `string` | n/a | yes |
| <a name="input_customer_policy_name"></a> [customer\_policy\_name](#input\_customer\_policy\_name) | The customer IAM policy name | `string` | n/a | yes |
| <a name="input_kms_key"></a> [kms\_key](#input\_kms\_key) | The kms\_key we use | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region which will be used. | `string` | n/a | yes |

## Outputs

No outputs.
