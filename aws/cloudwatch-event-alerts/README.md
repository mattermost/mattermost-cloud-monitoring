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
| [aws_db_event_subscription.rds_cluster_events_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_event_subscription) | resource |
| [aws_iam_role.lambda_role_rds_cluster_events](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.AWSLambdaBasicExecutionRole_alert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.rds_cluster_events](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.rds_cluster_events_topic_perm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_sns_topic.rds_cluster_events_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.rds_cluster_events_sub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_community_webhook"></a> [community\_webhook](#input\_community\_webhook) | The URL webhook to post the messages | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment | `string` | n/a | yes |
| <a name="input_opsgenie_apikey"></a> [opsgenie\_apikey](#input\_opsgenie\_apikey) | The API key for the OPSGenie integration | `string` | n/a | yes |
| <a name="input_opsgenie_scheduler_team"></a> [opsgenie\_scheduler\_team](#input\_opsgenie\_scheduler\_team) | The opsgenie scheduler team uuid  - not used on dev | `string` | n/a | yes |

## Outputs

No outputs.
