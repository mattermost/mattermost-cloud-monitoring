## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.40.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.40.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.es_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_resource_policy.es_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_resource_policy) | resource |
| [aws_cloudwatch_metric_alarm.cluster_index_writes_blocked](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.cluster_status_is_red](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.cluster_status_is_yellow](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.cpu_utilization_too_high](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.free_storage_space_too_low](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.insufficient_available_nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.jvm_memory_pressure_too_high](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.master_cpu_utilization_too_high](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.master_jvm_memory_pressure_too_high](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.master_not_reachable_from_node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_elasticsearch_domain.es_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticsearch_domain) | resource |
| [aws_route53_record.elasticsearch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.es_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_acm_certificate.internal_cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarm_name_postfix"></a> [alarm\_name\_postfix](#input\_alarm\_name\_postfix) | Alarm name postfix | `string` | `""` | no |
| <a name="input_alarm_name_prefix"></a> [alarm\_name\_prefix](#input\_alarm\_name\_prefix) | Alarm name prefix | `string` | `""` | no |
| <a name="input_audit_logs_enabled"></a> [audit\_logs\_enabled](#input\_audit\_logs\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_cloudwatch_log_group_arn"></a> [cloudwatch\_log\_group\_arn](#input\_cloudwatch\_log\_group\_arn) | n/a | `string` | n/a | yes |
| <a name="input_cpu_utilization_threshold"></a> [cpu\_utilization\_threshold](#input\_cpu\_utilization\_threshold) | The maximum percentage of CPU utilization | `number` | `80` | no |
| <a name="input_custom_endpoint_enabled"></a> [custom\_endpoint\_enabled](#input\_custom\_endpoint\_enabled) | n/a | `bool` | `true` | no |
| <a name="input_cw_retention_in_days"></a> [cw\_retention\_in\_days](#input\_cw\_retention\_in\_days) | n/a | `string` | `"90"` | no |
| <a name="input_dedicated_master_count"></a> [dedicated\_master\_count](#input\_dedicated\_master\_count) | n/a | `number` | n/a | yes |
| <a name="input_dedicated_master_enabled"></a> [dedicated\_master\_enabled](#input\_dedicated\_master\_enabled) | n/a | `bool` | n/a | yes |
| <a name="input_dedicated_master_type"></a> [dedicated\_master\_type](#input\_dedicated\_master\_type) | n/a | `string` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | n/a | `string` | n/a | yes |
| <a name="input_elasticsearch_access_policy_principal"></a> [elasticsearch\_access\_policy\_principal](#input\_elasticsearch\_access\_policy\_principal) | Which AWS resources should have access to the Elasticsearch cluster | `list(string)` | <pre>[<br>  "*"<br>]</pre> | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_es_instance_type"></a> [es\_instance\_type](#input\_es\_instance\_type) | n/a | `string` | n/a | yes |
| <a name="input_es_version"></a> [es\_version](#input\_es\_version) | n/a | `string` | n/a | yes |
| <a name="input_es_volume_size"></a> [es\_volume\_size](#input\_es\_volume\_size) | n/a | `string` | n/a | yes |
| <a name="input_es_zone_awareness"></a> [es\_zone\_awareness](#input\_es\_zone\_awareness) | n/a | `bool` | n/a | yes |
| <a name="input_es_zone_awareness_count"></a> [es\_zone\_awareness\_count](#input\_es\_zone\_awareness\_count) | n/a | `number` | n/a | yes |
| <a name="input_free_storage_space_threshold"></a> [free\_storage\_space\_threshold](#input\_free\_storage\_space\_threshold) | The minimum amount of available storage space in MegaByte. | `number` | `11000` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | n/a | `number` | n/a | yes |
| <a name="input_jvm_memory_pressure_threshold"></a> [jvm\_memory\_pressure\_threshold](#input\_jvm\_memory\_pressure\_threshold) | The maximum percentage of the Java heap used for all data nodes in the cluster | `number` | `80` | no |
| <a name="input_master_cpu_utilization_threshold"></a> [master\_cpu\_utilization\_threshold](#input\_master\_cpu\_utilization\_threshold) | The maximum percentage of CPU utilization of master nodes | `number` | `80` | no |
| <a name="input_master_jvm_memory_pressure_threshold"></a> [master\_jvm\_memory\_pressure\_threshold](#input\_master\_jvm\_memory\_pressure\_threshold) | The maximum percentage of the Java heap used for master nodes in the cluster | `number` | `80` | no |
| <a name="input_master_user_name"></a> [master\_user\_name](#input\_master\_user\_name) | The master user name for the Elasticsearch cluster | `string` | n/a | yes |
| <a name="input_master_user_password"></a> [master\_user\_password](#input\_master\_user\_password) | The master password for the Elasticsearch cluster | `string` | n/a | yes |
| <a name="input_mattermost_network"></a> [mattermost\_network](#input\_mattermost\_network) | n/a | `list(string)` | n/a | yes |
| <a name="input_min_available_nodes"></a> [min\_available\_nodes](#input\_min\_available\_nodes) | The minimum available (reachable) nodes to have | `number` | `1` | no |
| <a name="input_monitor_cluster_index_writes_blocked"></a> [monitor\_cluster\_index\_writes\_blocked](#input\_monitor\_cluster\_index\_writes\_blocked) | Enable monitoring of cluster index writes being blocked | `bool` | `true` | no |
| <a name="input_monitor_cluster_status_is_red"></a> [monitor\_cluster\_status\_is\_red](#input\_monitor\_cluster\_status\_is\_red) | Enable monitoring of cluster status is in red | `bool` | `true` | no |
| <a name="input_monitor_cluster_status_is_yellow"></a> [monitor\_cluster\_status\_is\_yellow](#input\_monitor\_cluster\_status\_is\_yellow) | Enable monitoring of cluster status is in yellow | `bool` | `true` | no |
| <a name="input_monitor_cpu_utilization_too_high"></a> [monitor\_cpu\_utilization\_too\_high](#input\_monitor\_cpu\_utilization\_too\_high) | Enable monitoring of CPU utilization is too high | `bool` | `true` | no |
| <a name="input_monitor_free_storage_space_too_low"></a> [monitor\_free\_storage\_space\_too\_low](#input\_monitor\_free\_storage\_space\_too\_low) | Enable monitoring of cluster average free storage is to low | `bool` | `true` | no |
| <a name="input_monitor_insufficient_available_nodes"></a> [monitor\_insufficient\_available\_nodes](#input\_monitor\_insufficient\_available\_nodes) | Enable monitoring insufficient available nodes | `bool` | `true` | no |
| <a name="input_monitor_jvm_memory_pressure_too_high"></a> [monitor\_jvm\_memory\_pressure\_too\_high](#input\_monitor\_jvm\_memory\_pressure\_too\_high) | Enable monitoring of JVM memory pressure is too high | `bool` | `true` | no |
| <a name="input_monitor_master_cpu_utilization_too_high"></a> [monitor\_master\_cpu\_utilization\_too\_high](#input\_monitor\_master\_cpu\_utilization\_too\_high) | Enable monitoring of CPU utilization of master nodes are too high. Only enable this when dedicated master is enabled | `bool` | `true` | no |
| <a name="input_monitor_master_jvm_memory_pressure_too_high"></a> [monitor\_master\_jvm\_memory\_pressure\_too\_high](#input\_monitor\_master\_jvm\_memory\_pressure\_too\_high) | Enable monitoring of JVM memory pressure of master nodes are too high. Only enable this wwhen dedicated master is enabled | `bool` | `true` | no |
| <a name="input_monitor_master_not_reachable_from_node"></a> [monitor\_master\_not\_reachable\_from\_node](#input\_monitor\_master\_not\_reachable\_from\_node) | Enable monitoring when master is not reachable from nodes | `bool` | `true` | no |
| <a name="input_private_hosted_zoneid"></a> [private\_hosted\_zoneid](#input\_private\_hosted\_zoneid) | n/a | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | n/a | `list(string)` | n/a | yes |
| <a name="input_tls_security_policy"></a> [tls\_security\_policy](#input\_tls\_security\_policy) | n/a | `string` | `"Policy-Min-TLS-1-0-2019-07"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | n/a | yes |
| <a name="input_vpn_cidr"></a> [vpn\_cidr](#input\_vpn\_cidr) | n/a | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | The Domain-specific endpoint used to submit index, search, and data upload requests. |
