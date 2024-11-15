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
| [aws_cloudwatch_event_rule.grant-privileges-to-schemas](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.grant-privileges-to-schemas](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_iam_role.grant-privileges-to-schemas_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.grant-privileges-to-schemas_lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.AWSLambdaBasicExecutionRoleGrantPrivilegesToSchemas](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AWSLambdaVPCAccessExecutionRoleGrantPrivilegesToSchemas](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.grant-privileges-to-schemas](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.allow_cloudwatch_to_call_grant-privileges-to-schemas](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_security_group.grant-privileges-to-schemas_lambda_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_activity_date"></a> [activity\_date](#input\_activity\_date) | n/a | `string` | n/a | yes |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | n/a | `string` | n/a | yes |
| <a name="input_deployment_name"></a> [deployment\_name](#input\_deployment\_name) | The name of the deployment for Lambda | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment which will deploy to and will be added as a tag | `string` | n/a | yes |
| <a name="input_excluded_clusters"></a> [excluded\_clusters](#input\_excluded\_clusters) | n/a | `string` | n/a | yes |
| <a name="input_grant-privileges-to-schemas_lambda_schedule"></a> [grant-privileges-to-schemas\_lambda\_schedule](#input\_grant-privileges-to-schemas\_lambda\_schedule) | The schedule for AWS Cloud Lambda event rule | `string` | n/a | yes |
| <a name="input_lambda_s3_bucket"></a> [lambda\_s3\_bucket](#input\_lambda\_s3\_bucket) | The S3 bucket where the lambda function is stored | `string` | n/a | yes |
| <a name="input_lambda_s3_key"></a> [lambda\_s3\_key](#input\_lambda\_s3\_key) | The S3 key where the lambda function is stored | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | The list of the private subnet IDs | `list(string)` | n/a | yes |
| <a name="input_provisioner_db_url"></a> [provisioner\_db\_url](#input\_provisioner\_db\_url) | n/a | `string` | n/a | yes |
| <a name="input_provisioner_db_user"></a> [provisioner\_db\_user](#input\_provisioner\_db\_user) | n/a | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the vpc for the security group of Lambda | `string` | n/a | yes |

## Outputs

No outputs.
