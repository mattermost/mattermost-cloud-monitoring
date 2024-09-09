<!-- BEGIN_TF_DOCS -->
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
| [aws_iam_policy.cluster-autoscaler-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.cluster-autoscaler-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.additional-role-policy-attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.cluster-autoscaler-policy-attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_role_name"></a> [additional\_role\_name](#input\_additional\_role\_name) | Existing role which needs to attach the same  policy | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment which will deploy to and will be added as a tag | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace, which host the service account & target application | `string` | n/a | yes |
| <a name="input_open_oidc_provider_arn"></a> [open\_oidc\_provider\_arn](#input\_open\_oidc\_provider\_arn) | The Open OIDC Provider ARN for a specific cluster | `string` | n/a | yes |
| <a name="input_open_oidc_provider_url"></a> [open\_oidc\_provider\_url](#input\_open\_oidc\_provider\_url) | The Open OIDC Provider URL for a specific cluster | `string` | n/a | yes |
| <a name="input_serviceaccount"></a> [serviceaccount](#input\_serviceaccount) | Service Account, with which we want to associate IAM permission | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->