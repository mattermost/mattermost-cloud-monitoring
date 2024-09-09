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
| [aws_s3_bucket.loki_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.loki_bucket_developers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.loki_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_acl.loki_bucket_developers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_policy.loki_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_policy.loki_bucket_developers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.loki_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.loki_bucket_developers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.loki_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_versioning.loki_bucket_developers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_iam_policy_document.loki_bucket_developers_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.loki_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_kms_key.master_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_loki_bucket_developers"></a> [enable\_loki\_bucket\_developers](#input\_enable\_loki\_bucket\_developers) | Whether to deploy Loki developers bucket or not | `bool` | n/a | yes |
| <a name="input_enable_loki_bucket_developers_restriction"></a> [enable\_loki\_bucket\_developers\_restriction](#input\_enable\_loki\_bucket\_developers\_restriction) | Whether to enable Loki developers bucket policy or not | `bool` | n/a | yes |
| <a name="input_enable_loki_bucket_restriction"></a> [enable\_loki\_bucket\_restriction](#input\_enable\_loki\_bucket\_restriction) | Whether to enable Loki bucket policy or not | `bool` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The cloud environment, dev, test, staging or prod. | `string` | n/a | yes |
| <a name="input_tags_bucket_loki_developers"></a> [tags\_bucket\_loki\_developers](#input\_tags\_bucket\_loki\_developers) | Tags for loki developers s3 bucket | `map(string)` | n/a | yes |
| <a name="input_tags_loki_bucket"></a> [tags\_loki\_bucket](#input\_tags\_loki\_bucket) | Tags for loki s3 bucket | `map(string)` | n/a | yes |

## Outputs

No outputs.
