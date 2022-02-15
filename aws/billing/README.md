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
| [aws_budgets_budget.cloud_budget](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/budgets_budget) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_amount"></a> [amount](#input\_amount) | The amount of cost or usage being measured for a budget | `string` | n/a | yes |
| <a name="input_currency"></a> [currency](#input\_currency) | The unit of measurement used for the budget eg. USD | `string` | n/a | yes |
| <a name="input_emails"></a> [emails](#input\_emails) | The emails in which the notification should be sent | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment | `string` | n/a | yes |
| <a name="input_sns_topic_arns"></a> [sns\_topic\_arns](#input\_sns\_topic\_arns) | The emails in which the notification should be sent | `string` | n/a | yes |
| <a name="input_threshold"></a> [threshold](#input\_threshold) | The threshold when the notification should be sent | `string` | n/a | yes |

## Outputs

No outputs.
