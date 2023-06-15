<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.61.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.61.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.rds-cluster-log-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_metric_alarm.db_instances_alarm_cpu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.db_instances_alarm_memory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_db_parameter_group.db_parameter_group_postgresql](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group) | resource |
| [aws_rds_cluster.provisioning_rds_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster_instance.provisioning_rds_db_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) | resource |
| [aws_rds_cluster_instance.provisioning_rds_db_instance_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) | resource |
| [aws_rds_cluster_parameter_group.cluster_parameter_group_postgresql](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_parameter_group) | resource |
| [aws_secretsmanager_secret.master_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.master_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [random_password.master_password](https://registry.terraform.io/providers/hashicorp/random/3.1.0/docs/resources/password) | resource |
| [random_string.db_cluster_identifier](https://registry.terraform.io/providers/hashicorp/random/3.1.0/docs/resources/string) | resource |
| [aws_iam_role.enhanced_monitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_sns_topic.aurora_cluster_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/sns_topic) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Specifies whether any cluster modifications are applied immediately, or during the next maintenance window | `bool` | n/a | yes |
| <a name="input_aurora_family"></a> [aurora\_family](#input\_aurora\_family) | The family of the DB parameter group. | `string` | `"aurora-postgresql12"` | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | The days to retain backups for | `string` | `"7"` | no |
| <a name="input_cluster_identifier"></a> [cluster\_identifier](#input\_cluster\_identifier) | The cluster identifier. If omitted, Terraform will assign a random, unique identifier. | `string` | n/a | yes |
| <a name="input_cluster_instance_identifier"></a> [cluster\_instance\_identifier](#input\_cluster\_instance\_identifier) | The cluster instance identifier. If omitted, Terraform will assign a random, unique identifier. | `string` | n/a | yes |
| <a name="input_copy_tags_to_snapshot"></a> [copy\_tags\_to\_snapshot](#input\_copy\_tags\_to\_snapshot) | Copy all Cluster tags to snapshots | `bool` | n/a | yes |
| <a name="input_creation_snapshot_arn"></a> [creation\_snapshot\_arn](#input\_creation\_snapshot\_arn) | The ARN of the snapshot to create from | `string` | `""` | no |
| <a name="input_db_subnet_group_name"></a> [db\_subnet\_group\_name](#input\_db\_subnet\_group\_name) | Required if publicly\_accessible = false, Optional otherwise, Forces new resource) A DB subnet group to associate with this DB instance. | `string` | n/a | yes |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Specifies if the DB instance should have deletion protection enabled | `bool` | n/a | yes |
| <a name="input_enable_rds_alerting"></a> [enable\_rds\_alerting](#input\_enable\_rds\_alerting) | n/a | `bool` | `false` | no |
| <a name="input_enable_rds_reader"></a> [enable\_rds\_reader](#input\_enable\_rds\_reader) | n/a | `bool` | `true` | no |
| <a name="input_enabled_cloudwatch_logs_exports"></a> [enabled\_cloudwatch\_logs\_exports](#input\_enabled\_cloudwatch\_logs\_exports) | Set of log types to enable for exporting to CloudWatch logs | `list(string)` | n/a | yes |
| <a name="input_engine"></a> [engine](#input\_engine) | The database engine to use | `string` | `"aurora-postgresql"` | no |
| <a name="input_engine_mode"></a> [engine\_mode](#input\_engine\_mode) | The engine mode to use | `string` | `"provisioned"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | The engine version to use | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment which will deploy to and will be added as a tag | `string` | n/a | yes |
| <a name="input_final_snapshot_identifier_prefix"></a> [final\_snapshot\_identifier\_prefix](#input\_final\_snapshot\_identifier\_prefix) | The prefix name of your final DB snapshot when this DB instance is deleted | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type of the RDS instance | `string` | `""` | no |
| <a name="input_kms_key"></a> [kms\_key](#input\_kms\_key) | Key to keep your storage data encrypted at rest in all underlying storage for DB clusters. | `string` | n/a | yes |
| <a name="input_log_min_duration_statement"></a> [log\_min\_duration\_statement](#input\_log\_min\_duration\_statement) | n/a | `number` | `2000` | no |
| <a name="input_max_capacity"></a> [max\_capacity](#input\_max\_capacity) | The maximum capacity for an Aurora DB cluster in provisioned DB engine mode. | `number` | n/a | yes |
| <a name="input_memory_alarm_limit"></a> [memory\_alarm\_limit](#input\_memory\_alarm\_limit) | Limit to trigger memory alarm. Number in Bytes (100MB) | `string` | `"100000000"` | no |
| <a name="input_memory_cache_proportion"></a> [memory\_cache\_proportion](#input\_memory\_cache\_proportion) | Proportion of memory that is used for cache. By default it is 75%. | `number` | `0.75` | no |
| <a name="input_min_capacity"></a> [min\_capacity](#input\_min\_capacity) | The minimum capacity for an Aurora DB cluster in provisioned DB engine mode. | `number` | n/a | yes |
| <a name="input_monitoring_interval"></a> [monitoring\_interval](#input\_monitoring\_interval) | The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance | `number` | n/a | yes |
| <a name="input_password"></a> [password](#input\_password) | If empty a random password will be created for each RDS Cluster and stored in AWS Secret Management. | `string` | n/a | yes |
| <a name="input_performance_insights_enabled"></a> [performance\_insights\_enabled](#input\_performance\_insights\_enabled) | Specifies whether Performance Insights are enabled | `bool` | n/a | yes |
| <a name="input_performance_insights_retention_period"></a> [performance\_insights\_retention\_period](#input\_performance\_insights\_retention\_period) | Amount of time in days to retain Performance Insights data | `number` | n/a | yes |
| <a name="input_port"></a> [port](#input\_port) | The port on which the DB accepts connections | `string` | `"5432"` | no |
| <a name="input_preferred_backup_window"></a> [preferred\_backup\_window](#input\_preferred\_backup\_window) | The daily time range during which automated backups are created if automated backups are enabled using the BackupRetentionPeriod parameter | `string` | n/a | yes |
| <a name="input_preferred_maintenance_window"></a> [preferred\_maintenance\_window](#input\_preferred\_maintenance\_window) | The window to perform maintenance in | `string` | n/a | yes |
| <a name="input_publicly_accessible"></a> [publicly\_accessible](#input\_publicly\_accessible) | Bool to control if instance is publicly accessible | `bool` | `false` | no |
| <a name="input_ram_memory_bytes"></a> [ram\_memory\_bytes](#input\_ram\_memory\_bytes) | The RAM memory of each instance type in Bytes. | `map(any)` | <pre>{<br>  "db.r5.12xlarge": "412316860416",<br>  "db.r5.16xlarge": "549755813888",<br>  "db.r5.24xlarge": "824633720832",<br>  "db.r5.2xlarge": "68719476736",<br>  "db.r5.4xlarge": "137438953472",<br>  "db.r5.8xlarge": "274877906944",<br>  "db.r5.large": "17179869184",<br>  "db.r5.xlarge": "34359738368",<br>  "db.r6g.12xlarge": "412316860416",<br>  "db.r6g.16xlarge": "549755813888",<br>  "db.r6g.24xlarge": "824633720832",<br>  "db.r6g.2xlarge": "68719476736",<br>  "db.r6g.4xlarge": "137438953472",<br>  "db.r6g.8xlarge": "274877906944",<br>  "db.r6g.large": "17179869184",<br>  "db.r6g.xlarge": "34359738368",<br>  "db.t3.large": "8589934592",<br>  "db.t3.medium": "4294967296",<br>  "db.t3.small": "2147483648",<br>  "db.t4g.large": "8589934592",<br>  "db.t4g.medium": "4294967296",<br>  "db.t4g.small": "2147483648"<br>}</pre> | no |
| <a name="input_rds_sns_topic"></a> [rds\_sns\_topic](#input\_rds\_sns\_topic) | RDS events sns topic | `string` | `"rds-cluster-events"` | no |
| <a name="input_replica_min"></a> [replica\_min](#input\_replica\_min) | Number of replicas to deploy initially with the RDS Cluster. | `number` | n/a | yes |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | THe name of the service | `string` | n/a | yes |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Determines whether a final DB snapshot is created before the DB instance is deleted | `bool` | n/a | yes |
| <a name="input_storage_encrypted"></a> [storage\_encrypted](#input\_storage\_encrypted) | Specifies whether the DB cluster is encrypted | `bool` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resource | `map(string)` | `{}` | no |
| <a name="input_username"></a> [username](#input\_username) | Username for the master DB user | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID of the database cluster | `string` | n/a | yes |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | The IDs of the security groups that will be assigned to the cluster nodes | `list(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->