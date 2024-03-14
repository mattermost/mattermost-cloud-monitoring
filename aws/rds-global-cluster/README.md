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
| <a name="provider_aws.primary"></a> [aws.primary](#provider\_aws.primary) | >= 5.40.0 |
| <a name="provider_aws.secondary"></a> [aws.secondary](#provider\_aws.secondary) | >= 5.40.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.rds-cluster-log-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_db_parameter_group.db_parameter_group_postgresql](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group) | resource |
| [aws_rds_cluster.primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster.secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster_instance.primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) | resource |
| [aws_rds_cluster_instance.secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) | resource |
| [aws_rds_cluster_parameter_group.cluster_parameter_group_postgresql](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_parameter_group) | resource |
| [aws_rds_global_cluster.global-cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_global_cluster) | resource |
| [aws_iam_role.enhanced_monitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Specifies whether any cluster modifications are applied immediately, or during the next maintenance window | `bool` | n/a | yes |
| <a name="input_aurora_family"></a> [aurora\_family](#input\_aurora\_family) | The family of the DB parameter group. | `string` | `"aurora-postgresql12"` | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | (Optional) The days to retain backups for. Default 1. | `number` | `1` | no |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | (Forces new resources) Name for an automatically created database on cluster creation. | `string` | n/a | yes |
| <a name="input_engine"></a> [engine](#input\_engine) | Name of the database engine to be used for this DB cluster. Terraform will only perform drift detection if a configuration value is provided. Valid values: aurora, aurora-mysql, aurora-postgresql. | `string` | n/a | yes |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Engine version of the Aurora global database. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment which will deploy to and will be added as a tag | `string` | n/a | yes |
| <a name="input_global_cluster_identifier"></a> [global\_cluster\_identifier](#input\_global\_cluster\_identifier) | (Required, Forces new resources) Global cluster identifier. | `string` | n/a | yes |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | instance class like db.r4.large etc. | `string` | n/a | yes |
| <a name="input_log_min_duration_statement"></a> [log\_min\_duration\_statement](#input\_log\_min\_duration\_statement) | n/a | `number` | `2000` | no |
| <a name="input_master_password"></a> [master\_password](#input\_master\_password) | Master password for rds cluster. | `string` | n/a | yes |
| <a name="input_master_username"></a> [master\_username](#input\_master\_username) | Master username for rds cluster. | `string` | n/a | yes |
| <a name="input_monitoring_interval"></a> [monitoring\_interval](#input\_monitoring\_interval) | The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance | `number` | n/a | yes |
| <a name="input_performance_insights_enabled"></a> [performance\_insights\_enabled](#input\_performance\_insights\_enabled) | Specifies whether Performance Insights are enabled | `bool` | n/a | yes |
| <a name="input_performance_insights_retention_period"></a> [performance\_insights\_retention\_period](#input\_performance\_insights\_retention\_period) | Amount of time in days to retain Performance Insights data | `number` | `7` | no |
| <a name="input_preferred_backup_window"></a> [preferred\_backup\_window](#input\_preferred\_backup\_window) | The daily time range during which automated backups are created if automated backups are enabled using the BackupRetentionPeriod parameter.Time in UTC. | `string` | `"02:00-03:00"` | no |
| <a name="input_primary_cluster_identifier"></a> [primary\_cluster\_identifier](#input\_primary\_cluster\_identifier) | Primary cluster identifier. | `string` | n/a | yes |
| <a name="input_primary_db_subnet_group_name"></a> [primary\_db\_subnet\_group\_name](#input\_primary\_db\_subnet\_group\_name) | db subnet group name. | `string` | `"default"` | no |
| <a name="input_primary_instances_count"></a> [primary\_instances\_count](#input\_primary\_instances\_count) | Specify number of primary instances. | `number` | `2` | no |
| <a name="input_primary_kms_key"></a> [primary\_kms\_key](#input\_primary\_kms\_key) | Key to keep your storage data encrypted at rest in all underlying storage for DB clusters. | `string` | n/a | yes |
| <a name="input_primary_vpc_id"></a> [primary\_vpc\_id](#input\_primary\_vpc\_id) | The VPC ID of the primary database cluster | `string` | n/a | yes |
| <a name="input_primary_vpc_security_group_ids"></a> [primary\_vpc\_security\_group\_ids](#input\_primary\_vpc\_security\_group\_ids) | The IDs of the security groups that will be assigned to the cluster nodes | `list(string)` | n/a | yes |
| <a name="input_secondary_cluster_identifier"></a> [secondary\_cluster\_identifier](#input\_secondary\_cluster\_identifier) | secondary cluster identifier. | `string` | n/a | yes |
| <a name="input_secondary_db_subnet_group_name"></a> [secondary\_db\_subnet\_group\_name](#input\_secondary\_db\_subnet\_group\_name) | db subnet group name. | `string` | `"default"` | no |
| <a name="input_secondary_instances_count"></a> [secondary\_instances\_count](#input\_secondary\_instances\_count) | Specify number of secondary instances. | `number` | `1` | no |
| <a name="input_secondary_kms_key"></a> [secondary\_kms\_key](#input\_secondary\_kms\_key) | Key to keep your storage data encrypted at rest in all underlying storage for DB clusters. | `string` | n/a | yes |
| <a name="input_secondary_vpc_id"></a> [secondary\_vpc\_id](#input\_secondary\_vpc\_id) | The VPC ID of the secondary database cluster | `string` | n/a | yes |
| <a name="input_secondary_vpc_security_group_ids"></a> [secondary\_vpc\_security\_group\_ids](#input\_secondary\_vpc\_security\_group\_ids) | The IDs of the security groups that will be assigned to the cluster nodes | `list(string)` | n/a | yes |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Determines whether a final DB snapshot is created before the DB cluster is deleted. | `bool` | `false` | no |
| <a name="input_source_region"></a> [source\_region](#input\_source\_region) | The source region for an encrypted replica DB cluster. | `string` | n/a | yes |
| <a name="input_storage_encrypted"></a> [storage\_encrypted](#input\_storage\_encrypted) | Specifies whether the DB cluster is encrypted | `bool` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for Global Cluster & instances. | `map(string)` | `{}` | no |
| <a name="input_target_region"></a> [target\_region](#input\_target\_region) | The target region for an encrypted replica DB cluster. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
