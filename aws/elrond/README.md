<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.61.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.61.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aurora-cluster"></a> [aurora-cluster](#module\_aurora-cluster) | github.com/mattermost/mattermost-cloud-monitoring.git//aws/aurora-cluster | v1.6.17 |

## Resources

| Name | Type |
|------|------|
| [aws_db_subnet_group.subnets_db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_security_group.cnc_to_elrond_postgress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [terraform_remote_state.cluster](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_vpn_cidr"></a> [cloud\_vpn\_cidr](#input\_cloud\_vpn\_cidr) | The cidr of the Cloud VPN to allow access from | `list(string)` | n/a | yes |
| <a name="input_db_backup_retention_period"></a> [db\_backup\_retention\_period](#input\_db\_backup\_retention\_period) | The Elrond DB backup retention period | `string` | n/a | yes |
| <a name="input_db_backup_window"></a> [db\_backup\_window](#input\_db\_backup\_window) | The Elrond DB backup window | `string` | n/a | yes |
| <a name="input_db_deletion_protection"></a> [db\_deletion\_protection](#input\_db\_deletion\_protection) | Whether to enable DB deletion protection or not | `bool` | `true` | no |
| <a name="input_db_maintenance_window"></a> [db\_maintenance\_window](#input\_db\_maintenance\_window) | The Elrond DB maintenance window | `string` | n/a | yes |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | The Elrond DB password | `string` | n/a | yes |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | The Elrond DB username | `string` | n/a | yes |
| <a name="input_elrond_apply_immediately"></a> [elrond\_apply\_immediately](#input\_elrond\_apply\_immediately) | n/a | `bool` | `false` | no |
| <a name="input_elrond_aurora_family"></a> [elrond\_aurora\_family](#input\_elrond\_aurora\_family) | n/a | `string` | `"aurora-postgresql13"` | no |
| <a name="input_elrond_cluster_storage_encrypted"></a> [elrond\_cluster\_storage\_encrypted](#input\_elrond\_cluster\_storage\_encrypted) | n/a | `bool` | `true` | no |
| <a name="input_elrond_copy_tags_to_snapshot"></a> [elrond\_copy\_tags\_to\_snapshot](#input\_elrond\_copy\_tags\_to\_snapshot) | n/a | `bool` | `true` | no |
| <a name="input_elrond_db_cluster_engine"></a> [elrond\_db\_cluster\_engine](#input\_elrond\_db\_cluster\_engine) | n/a | `string` | `"aurora-postgresql"` | no |
| <a name="input_elrond_db_cluster_engine_mode"></a> [elrond\_db\_cluster\_engine\_mode](#input\_elrond\_db\_cluster\_engine\_mode) | n/a | `string` | `"provisioned"` | no |
| <a name="input_elrond_db_cluster_engine_version"></a> [elrond\_db\_cluster\_engine\_version](#input\_elrond\_db\_cluster\_engine\_version) | n/a | `string` | `"13.8"` | no |
| <a name="input_elrond_db_cluster_identifier"></a> [elrond\_db\_cluster\_identifier](#input\_elrond\_db\_cluster\_identifier) | n/a | `string` | n/a | yes |
| <a name="input_elrond_db_cluster_instance_identifier"></a> [elrond\_db\_cluster\_instance\_identifier](#input\_elrond\_db\_cluster\_instance\_identifier) | n/a | `string` | n/a | yes |
| <a name="input_elrond_db_cluster_instance_type"></a> [elrond\_db\_cluster\_instance\_type](#input\_elrond\_db\_cluster\_instance\_type) | n/a | `string` | `"db.serverless"` | no |
| <a name="input_elrond_enabled_cloudwatch_logs_exports"></a> [elrond\_enabled\_cloudwatch\_logs\_exports](#input\_elrond\_enabled\_cloudwatch\_logs\_exports) | n/a | `list(string)` | <pre>[<br>  "postgresql"<br>]</pre> | no |
| <a name="input_elrond_kms_key"></a> [elrond\_kms\_key](#input\_elrond\_kms\_key) | n/a | `string` | n/a | yes |
| <a name="input_elrond_max_capacity"></a> [elrond\_max\_capacity](#input\_elrond\_max\_capacity) | n/a | `number` | `4` | no |
| <a name="input_elrond_min_capacity"></a> [elrond\_min\_capacity](#input\_elrond\_min\_capacity) | n/a | `number` | `0.5` | no |
| <a name="input_elrond_monitoring_interval"></a> [elrond\_monitoring\_interval](#input\_elrond\_monitoring\_interval) | n/a | `number` | n/a | yes |
| <a name="input_elrond_performance_insights_enabled"></a> [elrond\_performance\_insights\_enabled](#input\_elrond\_performance\_insights\_enabled) | n/a | `bool` | n/a | yes |
| <a name="input_elrond_performance_insights_retention_period"></a> [elrond\_performance\_insights\_retention\_period](#input\_elrond\_performance\_insights\_retention\_period) | n/a | `number` | `7` | no |
| <a name="input_elrond_replica_min"></a> [elrond\_replica\_min](#input\_elrond\_replica\_min) | n/a | `number` | n/a | yes |
| <a name="input_elrond_service_name"></a> [elrond\_service\_name](#input\_elrond\_service\_name) | n/a | `string` | `"elrond"` | no |
| <a name="input_enable_elrond_read_replica"></a> [enable\_elrond\_read\_replica](#input\_enable\_elrond\_read\_replica) | n/a | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment to deploy the Elrond resources, dev, test, etc. | `string` | n/a | yes |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | The Elrond DB private subnets | `list(string)` | n/a | yes |
| <a name="input_provider_role_arn"></a> [provider\_role\_arn](#input\_provider\_role\_arn) | The provider IAM role arn | `string` | `""` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC to deploy the Elrond resources | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
