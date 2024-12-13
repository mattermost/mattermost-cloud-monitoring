## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.41.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.41.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aurora-cluster"></a> [aurora-cluster](#module\_aurora-cluster) | github.com/mattermost/mattermost-cloud-monitoring.git//aws/aurora-cluster | v1.7.5 |

## Resources

| Name | Type |
|------|------|
| [aws_db_subnet_group.grafana_subnets_db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_security_group.grafana_cec_to_postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [terraform_remote_state.cluster](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_vpn_cidr"></a> [cloud\_vpn\_cidr](#input\_cloud\_vpn\_cidr) | n/a | `list(string)` | n/a | yes |
| <a name="input_db_backup_retention_period"></a> [db\_backup\_retention\_period](#input\_db\_backup\_retention\_period) | n/a | `number` | n/a | yes |
| <a name="input_db_backup_window"></a> [db\_backup\_window](#input\_db\_backup\_window) | n/a | `string` | n/a | yes |
| <a name="input_db_deletion_protection"></a> [db\_deletion\_protection](#input\_db\_deletion\_protection) | n/a | `bool` | `true` | no |
| <a name="input_db_maintenance_window"></a> [db\_maintenance\_window](#input\_db\_maintenance\_window) | n/a | `string` | n/a | yes |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | n/a | `string` | n/a | yes |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | n/a | `string` | n/a | yes |
| <a name="input_enable_grafana_read_replica"></a> [enable\_grafana\_read\_replica](#input\_enable\_grafana\_read\_replica) | n/a | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_grafana_apply_immediately"></a> [grafana\_apply\_immediately](#input\_grafana\_apply\_immediately) | n/a | `bool` | `false` | no |
| <a name="input_grafana_aurora_family"></a> [grafana\_aurora\_family](#input\_grafana\_aurora\_family) | n/a | `string` | `"aurora-postgresql13"` | no |
| <a name="input_grafana_ca_cert_identifier"></a> [grafana\_ca\_cert\_identifier](#input\_grafana\_ca\_cert\_identifier) | Identifier of the CA certificate for the DB instance. | `string` | `"rds-ca-rsa4096-g1"` | no |
| <a name="input_grafana_cluster_storage_encrypted"></a> [grafana\_cluster\_storage\_encrypted](#input\_grafana\_cluster\_storage\_encrypted) | n/a | `bool` | `true` | no |
| <a name="input_grafana_copy_tags_to_snapshot"></a> [grafana\_copy\_tags\_to\_snapshot](#input\_grafana\_copy\_tags\_to\_snapshot) | n/a | `bool` | `true` | no |
| <a name="input_grafana_db_cluster_engine"></a> [grafana\_db\_cluster\_engine](#input\_grafana\_db\_cluster\_engine) | n/a | `string` | `"aurora-postgresql"` | no |
| <a name="input_grafana_db_cluster_engine_mode"></a> [grafana\_db\_cluster\_engine\_mode](#input\_grafana\_db\_cluster\_engine\_mode) | n/a | `string` | `"provisioned"` | no |
| <a name="input_grafana_db_cluster_engine_version"></a> [grafana\_db\_cluster\_engine\_version](#input\_grafana\_db\_cluster\_engine\_version) | n/a | `string` | `"13.8"` | no |
| <a name="input_grafana_db_cluster_identifier"></a> [grafana\_db\_cluster\_identifier](#input\_grafana\_db\_cluster\_identifier) | n/a | `string` | n/a | yes |
| <a name="input_grafana_db_cluster_instance_identifier"></a> [grafana\_db\_cluster\_instance\_identifier](#input\_grafana\_db\_cluster\_instance\_identifier) | n/a | `string` | n/a | yes |
| <a name="input_grafana_db_cluster_instance_type"></a> [grafana\_db\_cluster\_instance\_type](#input\_grafana\_db\_cluster\_instance\_type) | n/a | `string` | `"db.serverless"` | no |
| <a name="input_grafana_enable_rds_alerting"></a> [grafana\_enable\_rds\_alerting](#input\_grafana\_enable\_rds\_alerting) | n/a | `bool` | `false` | no |
| <a name="input_grafana_enabled_cloudwatch_logs_exports"></a> [grafana\_enabled\_cloudwatch\_logs\_exports](#input\_grafana\_enabled\_cloudwatch\_logs\_exports) | n/a | `list(string)` | <pre>[<br>  "postgresql"<br>]</pre> | no |
| <a name="input_grafana_kms_key"></a> [grafana\_kms\_key](#input\_grafana\_kms\_key) | n/a | `string` | n/a | yes |
| <a name="input_grafana_max_capacity"></a> [grafana\_max\_capacity](#input\_grafana\_max\_capacity) | n/a | `number` | `4` | no |
| <a name="input_grafana_min_capacity"></a> [grafana\_min\_capacity](#input\_grafana\_min\_capacity) | n/a | `number` | `0.5` | no |
| <a name="input_grafana_monitoring_interval"></a> [grafana\_monitoring\_interval](#input\_grafana\_monitoring\_interval) | n/a | `number` | n/a | yes |
| <a name="input_grafana_performance_insights_enabled"></a> [grafana\_performance\_insights\_enabled](#input\_grafana\_performance\_insights\_enabled) | n/a | `bool` | n/a | yes |
| <a name="input_grafana_performance_insights_retention_period"></a> [grafana\_performance\_insights\_retention\_period](#input\_grafana\_performance\_insights\_retention\_period) | n/a | `number` | n/a | yes |
| <a name="input_grafana_replica_min"></a> [grafana\_replica\_min](#input\_grafana\_replica\_min) | n/a | `number` | n/a | yes |
| <a name="input_grafana_service_name"></a> [grafana\_service\_name](#input\_grafana\_service\_name) | n/a | `string` | `"grafana"` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | n/a | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
