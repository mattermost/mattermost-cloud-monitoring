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
| [aws_iam_policy.cloudwatch_db_factory_vertical_scaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.ec2_db_factory_horizontal_scaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.rds_db_factory_vertical_scaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.sqs_db_factory_vertical_scaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.tag_db_factory_horizontal_scaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_user_policy_attachment.attach_cloudwatch_db_factory_vertical_scaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.attach_ec2_db_factory_horizontal_scaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.attach_rds_db_factory_vertical_scaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.attach_sqs_db_factory_vertical_scaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.attach_tag_db_factory_horizontal_scaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_sns_topic.vertical_scaling_sns_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.vertical_scaling_sns_topic_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_sns_topic_subscription.vertical_scaling_sns_topic_subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_sqs_queue.vertical_scaling_sqs_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue_policy.vertical_scaling_sqs_queue_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.sns_topic_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_db_factory_horizontal_scaling_users"></a> [db\_factory\_horizontal\_scaling\_users](#input\_db\_factory\_horizontal\_scaling\_users) | The list of IAM users who have specific access for horizontal scaling | `list(string)` | n/a | yes |
| <a name="input_db_factory_vertical_scaling_users"></a> [db\_factory\_vertical\_scaling\_users](#input\_db\_factory\_vertical\_scaling\_users) | The list of IAM users who have specific access for vertical scaling | `list(string)` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment will be created | `string` | n/a | yes |
| <a name="input_rds_multitenant_dbinstance_name_prefix"></a> [rds\_multitenant\_dbinstance\_name\_prefix](#input\_rds\_multitenant\_dbinstance\_name\_prefix) | The name of RDS db instance prefix | `string` | n/a | yes |

## Outputs

No outputs.
