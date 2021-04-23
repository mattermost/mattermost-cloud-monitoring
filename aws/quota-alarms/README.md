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
| [aws_cloudwatch_metric_alarm.grafana_metrics](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarm_threshold"></a> [alarm\_threshold](#input\_alarm\_threshold) | The threshold which is used for CloudWatch Metric alarm | `string` | n/a | yes |
| <a name="input_metrics"></a> [metrics](#input\_metrics) | The list of metrics to setup a CloudWatch Metric alarm | `list(string)` | n/a | yes |

## Outputs

No outputs.
