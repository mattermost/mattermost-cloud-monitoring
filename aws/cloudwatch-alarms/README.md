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
| [aws_cloudwatch_event_rule.lb_updates](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_rule.rds_updates](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.lb-registration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_event_target.rds-registration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_iam_role.lambda_role_create_elb_cloudwatch_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.lambda_role_create_rds_cloudwatch_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.lambda_role_receive_elb_cloudwatch_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.lambda_policy_create_elb_cloudwatch_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.lambda_policy_create_rds_cloudwatch_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.lambda_policy_receive_elb_cloudwatch_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.AWSLambdaBasicExecutionRole_alert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AWSLambdaBasicExecutionRole_create](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AWSLambdaBasicExecutionRole_rds_create](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.alert_elb_cloudwatch_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.create_elb_cloudwatch_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.create_rds_cloudwatch_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.allow_cloudwatch_to_call_lb_registration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.allow_cloudwatch_to_call_rds_registration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_sns_topic.elb_alarm_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.lamba_subscriber](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_community_webhook"></a> [community\_webhook](#input\_community\_webhook) | The URL webhook to post the messages | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment | `string` | n/a | yes |
| <a name="input_lambda_alert_elb_s3_key"></a> [lambda\_alert\_elb\_s3\_key](#input\_lambda\_alert\_elb\_s3\_key) | The S3 key where the alert ELB alarm lambda function is stored | `string` | n/a | yes |
| <a name="input_lambda_create_elb_s3_key"></a> [lambda\_create\_elb\_s3\_key](#input\_lambda\_create\_elb\_s3\_key) | The S3 key where the create ELB alarm lambda function is stored | `string` | n/a | yes |
| <a name="input_lambda_create_rds_s3_key"></a> [lambda\_create\_rds\_s3\_key](#input\_lambda\_create\_rds\_s3\_key) | The S3 key where the create RDS alarm lambda function is stored | `string` | n/a | yes |
| <a name="input_lambda_s3_bucket"></a> [lambda\_s3\_bucket](#input\_lambda\_s3\_bucket) | The S3 bucket where the lambda function is stored | `string` | n/a | yes |
| <a name="input_opsgenie_apikey"></a> [opsgenie\_apikey](#input\_opsgenie\_apikey) | The API key for the OPSGenie integration | `string` | n/a | yes |
| <a name="input_opsgenie_scheduler_team"></a> [opsgenie\_scheduler\_team](#input\_opsgenie\_scheduler\_team) | The opsgenie scheduler team uuid  - not used on dev | `string` | n/a | yes |

## Outputs

No outputs.
