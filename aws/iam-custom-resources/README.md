## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.99.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.99.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.github_oidc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_policy.db_disaster_recovery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.exports](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.packer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.plugin_store](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.pulumi-github-sync-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.db_disaster_recovery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.packer_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.plugin_store_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.private_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.pulumi-github-sync-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.db_disaster_recovery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.packer_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.plugin_store_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.private_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.pulumi-github-sync-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_user.exports](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy_attachment.exports](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_db_disaster_role"></a> [create\_db\_disaster\_role](#input\_create\_db\_disaster\_role) | Whether to create the DB disaster recovery role | `bool` | `false` | no |
| <a name="input_create_exports_user"></a> [create\_exports\_user](#input\_create\_exports\_user) | Whether to create the exports user | `bool` | `false` | no |
| <a name="input_create_packer_role"></a> [create\_packer\_role](#input\_create\_packer\_role) | Whether to create the packer role | `bool` | `false` | no |
| <a name="input_create_plugin_store_role"></a> [create\_plugin\_store\_role](#input\_create\_plugin\_store\_role) | Whether to create the plugin store role | `bool` | `false` | no |
| <a name="input_create_private_role"></a> [create\_private\_role](#input\_create\_private\_role) | Whether to create the private role | `bool` | `false` | no |
| <a name="input_create_pulumi_github_sync_role"></a> [create\_pulumi\_github\_sync\_role](#input\_create\_pulumi\_github\_sync\_role) | Whether to create the pulumi-github-sync role | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment | `string` | n/a | yes |
| <a name="input_exports_bucket_arn"></a> [exports\_bucket\_arn](#input\_exports\_bucket\_arn) | The bucket that will be used for data exports. Needed only when create\_exports\_users is set to true | `string` | `""` | no |
| <a name="input_github_repos_sub"></a> [github\_repos\_sub](#input\_github\_repos\_sub) | Github repos sub | `list(string)` | `[]` | no |
| <a name="input_github_runners_iam_role_arn"></a> [github\_runners\_iam\_role\_arn](#input\_github\_runners\_iam\_role\_arn) | Github runner role ARN | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_github_oidc_provider_arn"></a> [github\_oidc\_provider\_arn](#output\_github\_oidc\_provider\_arn) | ARN of the GitHub Actions OIDC provider |
