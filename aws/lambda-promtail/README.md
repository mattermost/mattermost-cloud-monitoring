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
| [aws_cloudwatch_log_group.lambda_promtail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_subscription_filter.lambdafunction_logfilter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_subscription_filter) | resource |
| [aws_iam_role.iam_for_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.lambda_vpc_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.lambda_promtail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function_event_invoke_config.lambda_promtail_invoke_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function_event_invoke_config) | resource |
| [aws_lambda_permission.allow-s3-invoke-lambda-promtail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.lambda_promtail_allow_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_s3_bucket_notification.push-to-lambda-promtail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_iam_policy.lambda_vpc_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_batch_size"></a> [batch\_size](#input\_batch\_size) | Determines when to flush the batch of logs (bytes). | `string` | `""` | no |
| <a name="input_bucket"></a> [bucket](#input\_bucket) | The S3 bucket where the binary is located | `string` | n/a | yes |
| <a name="input_bucket_names"></a> [bucket\_names](#input\_bucket\_names) | List of S3 bucket names to create Event Notifications for. | `list(string)` | `[]` | no |
| <a name="input_extra_labels"></a> [extra\_labels](#input\_extra\_labels) | Comma separated list of extra labels, in the format 'name1,value1,name2,value2,...,nameN,valueN' to add to entries forwarded by lambda-promtail. | `string` | `""` | no |
| <a name="input_keep_stream"></a> [keep\_stream](#input\_keep\_stream) | Determines whether to keep the CloudWatch Log Stream value as a Loki label when writing logs from lambda-promtail. | `string` | `"false"` | no |
| <a name="input_lambda_vpc_security_groups"></a> [lambda\_vpc\_security\_groups](#input\_lambda\_vpc\_security\_groups) | List of security group IDs associated with the Lambda function. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_lambda_vpc_subnets"></a> [lambda\_vpc\_subnets](#input\_lambda\_vpc\_subnets) | List of subnet IDs associated with the Lambda function. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_log_group_names"></a> [log\_group\_names](#input\_log\_group\_names) | List of CloudWatch Log Group names to create Subscription Filters for. | `list(string)` | `[]` | no |
| <a name="input_password"></a> [password](#input\_password) | The basic auth password, necessary if writing directly to Grafana Cloud Loki. | `string` | `""` | no |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Tenant ID to be added when writing logs from lambda-promtail. | `string` | `""` | no |
| <a name="input_username"></a> [username](#input\_username) | The basic auth username, necessary if writing directly to Grafana Cloud Loki. | `string` | `""` | no |
| <a name="input_write_address"></a> [write\_address](#input\_write\_address) | This is the Loki Write API compatible endpoint that you want to write logs to, either promtail or Loki. | `string` | `"http://localhost:8080/loki/api/v1/push"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->