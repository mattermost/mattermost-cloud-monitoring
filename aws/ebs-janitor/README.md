<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.ebs_janitor](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.ebs_janitor](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_iam_role.ebs_janitor_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.ebs_janitor_lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.AWSLambdaBasicExecutionRoleEBSJanitor](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AWSLambdaVPCAccessExecutionRoleEBSJanitor](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.ebs_janitor](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.allow_cloudwatch_to_call_ebs_janitor](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_security_group.ebs_janitor_lambda_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_alerts_lambda_schedule"></a> [account\_alerts\_lambda\_schedule](#input\_account\_alerts\_lambda\_schedule) | The schedule expression for a Cloudwatch Event rule to run Lambda periodically | `string` | n/a | yes |
| <a name="input_deployment_name"></a> [deployment\_name](#input\_deployment\_name) | The name of the deployment for Lambda | `string` | n/a | yes |
| <a name="input_dryrun"></a> [dryrun](#input\_dryrun) | Defines if lambda runs on dryRunMode or if does actual changes | `string` | `"true"` | no |
| <a name="input_ebs_janitor_lambda_schedule"></a> [ebs\_janitor\_lambda\_schedule](#input\_ebs\_janitor\_lambda\_schedule) | The schedule for AWS Cloud Lambda event rule | `string` | n/a | yes |
| <a name="input_mattermost_alerts_hook"></a> [mattermost\_alerts\_hook](#input\_mattermost\_alerts\_hook) | The URL webhook to send the alert which will be used in the lambda function as environment variable | `string` | n/a | yes |
| <a name="input_min_subnet_free_ips"></a> [min\_subnet\_free\_ips](#input\_min\_subnet\_free\_ips) | The number of free IPs which will be used in the lambda function as environment variable | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | The list of the private subnet IDs | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the vpc for the security group of Lambda | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->