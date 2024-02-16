<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.61.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.61.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.external-secrets-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.external-secrets-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.secret_access_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_secretsmanager_secret.external-secrets-app-secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.external-secrets-app-secret-version](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_applications"></a> [applications](#input\_applications) | A map of application names to their secrets | <pre>map(object({<br>    keys   = list(string)<br>    values = list(string)<br>  }))</pre> | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment which will deploy to and will be added as a tag | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace, which host the service account & target application | `string` | n/a | yes |
| <a name="input_open_oidc_provider_arn"></a> [open\_oidc\_provider\_arn](#input\_open\_oidc\_provider\_arn) | The Open OIDC Provider ARN for a specific cluster | `string` | n/a | yes |
| <a name="input_open_oidc_provider_url"></a> [open\_oidc\_provider\_url](#input\_open\_oidc\_provider\_url) | The Open OIDC Provider URL for a specific cluster | `string` | n/a | yes |
| <a name="input_serviceaccount"></a> [serviceaccount](#input\_serviceaccount) | Service Account, with which we want to associate IAM permission | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->