## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.40.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.40.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.logs_to_opensearch_errors](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_iam_role.logs_to_opensearch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.logs_to_opensearch_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lambda_function.logs_to_opensearch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_security_group.logs_to_opensearch_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_sns_topic.logs_to_opensearch_sns_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarm_evaluation_periods"></a> [alarm\_evaluation\_periods](#input\_alarm\_evaluation\_periods) | The number of periods over which data is compared to the specified threshold | `number` | `1` | no |
| <a name="input_alarm_period"></a> [alarm\_period](#input\_alarm\_period) | The period in seconds over which the specified statistic is applied | `number` | `10800` | no |
| <a name="input_alarm_threshold"></a> [alarm\_threshold](#input\_alarm\_threshold) | The value against which the specified statistic is compared | `number` | `1` | no |
| <a name="input_deployment_name"></a> [deployment\_name](#input\_deployment\_name) | The name of the deployment for Lambda | `string` | n/a | yes |
| <a name="input_es_endpoint"></a> [es\_endpoint](#input\_es\_endpoint) | The endpoint of AWS Opensearch service | `string` | n/a | yes |
| <a name="input_lambda_s3_bucket"></a> [lambda\_s3\_bucket](#input\_lambda\_s3\_bucket) | The S3 bucket where the lambda function is stored | `string` | n/a | yes |
| <a name="input_lambda_s3_key"></a> [lambda\_s3\_key](#input\_lambda\_s3\_key) | The S3 key where the lambda function is stored | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | The list of the private subnet IDs are used by logs-to-opensearch lambda | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of VPC is used by the logs-to-opensearch lamda | `string` | n/a | yes |

## Outputs

No outputs.
