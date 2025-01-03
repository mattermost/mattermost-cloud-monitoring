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
| [aws_cloudwatch_log_group.lambda_promtail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_subscription_filter.lambdafunction_logfilter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_subscription_filter) | resource |
| [aws_iam_role.promtail_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lambda_function.lambda_promtail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function_event_invoke_config.lambda_promtail_invoke_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function_event_invoke_config) | resource |
| [aws_lambda_permission.lambda_promtail_allow_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_security_group.lambda_promtail_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_batch_size"></a> [batch\_size](#input\_batch\_size) | Determines when to flush the batch of logs (bytes). | `string` | `""` | no |
| <a name="input_cloudwatch_log_group"></a> [cloudwatch\_log\_group](#input\_cloudwatch\_log\_group) | n/a | `string` | `"/aws/lambda/lambda_promtail"` | no |
| <a name="input_deployment_name"></a> [deployment\_name](#input\_deployment\_name) | The name of the deployment for Lambda | `string` | n/a | yes |
| <a name="input_enable_arm64"></a> [enable\_arm64](#input\_enable\_arm64) | Enable ARM64 architecture for Lambda | `bool` | `false` | no |
| <a name="input_extra_labels"></a> [extra\_labels](#input\_extra\_labels) | Comma separated list of extra labels, in the format 'name1,value1,name2,value2,...,nameN,valueN' to add to entries forwarded by lambda-promtail. | `string` | `""` | no |
| <a name="input_filter_pattern"></a> [filter\_pattern](#input\_filter\_pattern) | Determines pattern to parse logs. | `string` | `""` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | n/a | `string` | `"lambda-promtail"` | no |
| <a name="input_include_message"></a> [include\_message](#input\_include\_message) | Determines whether to include message as a Loki label when writing logs from lambda-promtail. | `string` | `"false"` | no |
| <a name="input_keep_stream"></a> [keep\_stream](#input\_keep\_stream) | Determines whether to keep the CloudWatch Log Stream value as a Loki label when writing logs from lambda-promtail. | `string` | `"false"` | no |
| <a name="input_lambda_s3_bucket"></a> [lambda\_s3\_bucket](#input\_lambda\_s3\_bucket) | The S3 bucket where the lambda function is stored | `string` | n/a | yes |
| <a name="input_lambda_s3_key"></a> [lambda\_s3\_key](#input\_lambda\_s3\_key) | The S3 key where the lambda function is stored | `string` | n/a | yes |
| <a name="input_log_group_names"></a> [log\_group\_names](#input\_log\_group\_names) | List of CloudWatch Log Group names to create Subscription Filters for. | `list(string)` | `[]` | no |
| <a name="input_password"></a> [password](#input\_password) | The basic auth password, necessary if writing directly to Grafana Cloud Loki. | `string` | `""` | no |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | The list of the private subnet IDs | `list(string)` | n/a | yes |
| <a name="input_promtail_lambda_iam_role"></a> [promtail\_lambda\_iam\_role](#input\_promtail\_lambda\_iam\_role) | n/a | `string` | `"promtail_lambda"` | no |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Tenant ID to be added when writing logs from lambda-promtail. | `string` | `""` | no |
| <a name="input_username"></a> [username](#input\_username) | The basic auth username, necessary if writing directly to Grafana Cloud Loki. | `string` | `""` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the vpc for the security group of Lambda | `string` | n/a | yes |
| <a name="input_write_address"></a> [write\_address](#input\_write\_address) | This is the Loki Write API compatible endpoint that you want to write logs to, either promtail or Loki. | `string` | `"http://localhost:8080/loki/api/v1/push"` | no |

## Outputs

No outputs.
