<!-- BEGIN_TF_DOCS -->
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
| [aws_cloudwatch_metric_alarm.db_instances_alarm_cpu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.db_instances_alarm_memory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_sns_topic.aurora_cluster_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/sns_topic) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_instance_identifier"></a> [cluster\_instance\_identifier](#input\_cluster\_instance\_identifier) | The rds aurora cluster identifier to set the alerm name | `string` | `""` | no |
| <a name="input_db_instance_identifier"></a> [db\_instance\_identifier](#input\_db\_instance\_identifier) | The rds database identifier to set the alerm name | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The rds database instance type to calculate the alarm limits | `string` | n/a | yes |
| <a name="input_memory_alarm_limit"></a> [memory\_alarm\_limit](#input\_memory\_alarm\_limit) | Limit to trigger memory alarm. Number in Bytes (100MB) | `string` | `"100000000"` | no |
| <a name="input_memory_cache_proportion"></a> [memory\_cache\_proportion](#input\_memory\_cache\_proportion) | Proportion of memory that is used for cache. By default it is 75%. | `number` | `0.75` | no |
| <a name="input_ram_memory_bytes"></a> [ram\_memory\_bytes](#input\_ram\_memory\_bytes) | The RAM memory of each instance type in Bytes. | `map(any)` | <pre>{<br>  "db.m6g.large": "8589934592",<br>  "db.r5.12xlarge": "412316860416",<br>  "db.r5.16xlarge": "549755813888",<br>  "db.r5.24xlarge": "824633720832",<br>  "db.r5.2xlarge": "68719476736",<br>  "db.r5.4xlarge": "137438953472",<br>  "db.r5.8xlarge": "274877906944",<br>  "db.r5.large": "17179869184",<br>  "db.r5.xlarge": "34359738368",<br>  "db.r6g.12xlarge": "412316860416",<br>  "db.r6g.16xlarge": "549755813888",<br>  "db.r6g.24xlarge": "824633720832",<br>  "db.r6g.2xlarge": "68719476736",<br>  "db.r6g.4xlarge": "137438953472",<br>  "db.r6g.8xlarge": "274877906944",<br>  "db.r6g.large": "17179869184",<br>  "db.r6g.xlarge": "34359738368",<br>  "db.t3.large": "8589934592",<br>  "db.t3.medium": "4294967296",<br>  "db.t3.small": "2147483648",<br>  "db.t4g.large": "8589934592",<br>  "db.t4g.medium": "4294967296",<br>  "db.t4g.small": "2147483648"<br>}</pre> | no |
| <a name="input_sns_topic"></a> [sns\_topic](#input\_sns\_topic) | The sns topic name to sent cloudwatch alarms | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resource | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
