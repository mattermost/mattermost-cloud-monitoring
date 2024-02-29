<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.5.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.2.1 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.5.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.5.0 |
| <a name="provider_aws.primary"></a> [aws.primary](#provider\_aws.primary) | >= 5.5.0 |
| <a name="provider_aws.secondary"></a> [aws.secondary](#provider\_aws.secondary) | >= 5.5.0 |
| <a name="provider_null"></a> [null](#provider\_null) | ~> 3.2.1 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.5.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_appautoscaling_policy.autoscaling_read_replica_count_primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_policy.autoscaling_read_replica_count_secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.read_replica_count_primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_appautoscaling_target.read_replica_count_secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_cloudwatch_log_group.rds-cluster-log-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_db_parameter_group.db_parameter_group_postgresql_primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group) | resource |
| [aws_db_parameter_group.db_parameter_group_postgresql_secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group) | resource |
| [aws_kms_alias.aurora_storage_alias_primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.aurora_storage_alias_secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.aurora_storage_key_primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.aurora_storage_key_secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_rds_cluster.provisioning_rds_cluster_primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster.provisioning_rds_cluster_secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster_instance.provisioning_rds_db_instance_primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) | resource |
| [aws_rds_cluster_instance.provisioning_rds_db_instance_secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) | resource |
| [aws_rds_cluster_parameter_group.cluster_parameter_group_postgresql_primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_parameter_group) | resource |
| [aws_rds_cluster_parameter_group.cluster_parameter_group_postgresql_secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_parameter_group) | resource |
| [aws_rds_global_cluster.global-cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_global_cluster) | resource |
| [aws_secretsmanager_secret.master_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.master_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [null_resource.enable_devops_guru_primary](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.enable_devops_guru_secondary](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_password.master_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_string.db_cluster_identifier](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_iam_role.enhanced_monitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_security_group.db_sg_primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_security_group.db_sg_secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_vpc.provisioning_vpc_primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [aws_vpc.provisioning_vpc_secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_major_version_upgrade"></a> [allow\_major\_version\_upgrade](#input\_allow\_major\_version\_upgrade) | Enable to allow major engine version upgrades when changing engine versions | `bool` | n/a | yes |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Specifies whether any cluster modifications are applied immediately, or during the next maintenance window | `bool` | n/a | yes |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | The days to retain backups for | `string` | n/a | yes |
| <a name="input_ca_cert_identifier"></a> [ca\_cert\_identifier](#input\_ca\_cert\_identifier) | Identifier of the CA certificate for the DB instance. | `string` | `"rds-ca-rsa4096-g1"` | no |
| <a name="input_copy_tags_to_snapshot"></a> [copy\_tags\_to\_snapshot](#input\_copy\_tags\_to\_snapshot) | Copy all Cluster tags to snapshots | `bool` | n/a | yes |
| <a name="input_creation_snapshot_arn_primary"></a> [creation\_snapshot\_arn\_primary](#input\_creation\_snapshot\_arn\_primary) | The primary ARN of the snapshot to create from | `string` | `""` | no |
| <a name="input_creation_snapshot_arn_secondary"></a> [creation\_snapshot\_arn\_secondary](#input\_creation\_snapshot\_arn\_secondary) | The primary ARN of the snapshot to create from | `string` | `""` | no |
| <a name="input_db_id"></a> [db\_id](#input\_db\_id) | The unique database ID of the cluster | `string` | n/a | yes |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Specifies if the DB instance should have deletion protection enabled | `bool` | n/a | yes |
| <a name="input_enable_devops_guru"></a> [enable\_devops\_guru](#input\_enable\_devops\_guru) | Set it to true will enable AWS Devops Guru service for DB instances within the cluster. | `bool` | n/a | yes |
| <a name="input_enable_global_cluster"></a> [enable\_global\_cluster](#input\_enable\_global\_cluster) | Whether to deploy a global RDS cluster | `bool` | n/a | yes |
| <a name="input_enabled_cloudwatch_logs_exports"></a> [enabled\_cloudwatch\_logs\_exports](#input\_enabled\_cloudwatch\_logs\_exports) | Set of log types to enable for exporting to CloudWatch logs | `list(string)` | n/a | yes |
| <a name="input_engine"></a> [engine](#input\_engine) | The database engine to use | `string` | n/a | yes |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | The engine version to use | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment which will deploy to and will be added as a tag | `string` | n/a | yes |
| <a name="input_final_snapshot_identifier_prefix"></a> [final\_snapshot\_identifier\_prefix](#input\_final\_snapshot\_identifier\_prefix) | The prefix name of your final DB snapshot when this DB instance is deleted | `string` | n/a | yes |
| <a name="input_global_database_name"></a> [global\_database\_name](#input\_global\_database\_name) | The database name for the global cluster. When creating global cluster from existing db cluster leave empty | `string` | `""` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type of the RDS instance | `string` | n/a | yes |
| <a name="input_kms_key_id_primary"></a> [kms\_key\_id\_primary](#input\_kms\_key\_id\_primary) | ARN for the primary KMS encryption key if one is set to the cluster | `string` | `""` | no |
| <a name="input_kms_key_id_secondary"></a> [kms\_key\_id\_secondary](#input\_kms\_key\_id\_secondary) | ARN for the secondary KMS encryption key if one is set to the cluster | `string` | `""` | no |
| <a name="input_log_min_duration_statement"></a> [log\_min\_duration\_statement](#input\_log\_min\_duration\_statement) | The duration of each completed statement to be logged. | `number` | n/a | yes |
| <a name="input_monitoring_interval"></a> [monitoring\_interval](#input\_monitoring\_interval) | The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance | `number` | n/a | yes |
| <a name="input_multitenant_tag"></a> [multitenant\_tag](#input\_multitenant\_tag) | The tag that will be applied and identify the type of multitenant DB cluster(multitenant-rds-dbproxy or multitenant-rds). | `string` | n/a | yes |
| <a name="input_password"></a> [password](#input\_password) | If empty a random password will be created for each RDS Cluster and stored in AWS Secret Management. | `string` | n/a | yes |
| <a name="input_performance_insights_enabled"></a> [performance\_insights\_enabled](#input\_performance\_insights\_enabled) | Specifies whether Performance Insights are enabled | `bool` | n/a | yes |
| <a name="input_performance_kms_key_id_primary"></a> [performance\_kms\_key\_id\_primary](#input\_performance\_kms\_key\_id\_primary) | ARN for the primary performance insights KMS encryption key if one is set to the cluster | `string` | `""` | no |
| <a name="input_performance_kms_key_id_secondary"></a> [performance\_kms\_key\_id\_secondary](#input\_performance\_kms\_key\_id\_secondary) | ARN for the secondary performance insights KMS encryption key if one is set to the cluster | `string` | `""` | no |
| <a name="input_port"></a> [port](#input\_port) | The port on which the DB accepts connections | `string` | n/a | yes |
| <a name="input_predefined_metric_type"></a> [predefined\_metric\_type](#input\_predefined\_metric\_type) | A predefined metric type | `string` | n/a | yes |
| <a name="input_preferred_backup_window"></a> [preferred\_backup\_window](#input\_preferred\_backup\_window) | The daily time range during which automated backups are created if automated backups are enabled using the BackupRetentionPeriod parameter | `string` | n/a | yes |
| <a name="input_preferred_maintenance_window"></a> [preferred\_maintenance\_window](#input\_preferred\_maintenance\_window) | The window to perform maintenance in | `string` | n/a | yes |
| <a name="input_primary_vpc_id"></a> [primary\_vpc\_id](#input\_primary\_vpc\_id) | The VPC ID of the primary database cluster | `string` | n/a | yes |
| <a name="input_ram_memory_bytes"></a> [ram\_memory\_bytes](#input\_ram\_memory\_bytes) | The RAM memory of each instance type in Bytes. A change in this variable should be reflected in database factory vertical scaling main.go as well. | `map(any)` | n/a | yes |
| <a name="input_random_page_cost"></a> [random\_page\_cost](#input\_random\_page\_cost) | Sets the planner's estimate of the cost of a non-sequentially-fetched disk page. The default is 4.0. This value can be overridden for tables and indexes in a particular tablespace by setting the tablespace parameter of the same name. | `number` | n/a | yes |
| <a name="input_replica_min_primary"></a> [replica\_min\_primary](#input\_replica\_min\_primary) | Number of replicas to deploy initially with the primary RDS Cluster. | `number` | n/a | yes |
| <a name="input_replica_min_secondary"></a> [replica\_min\_secondary](#input\_replica\_min\_secondary) | Number of replicas to deploy initially with the secondary RDS Cluster. | `number` | n/a | yes |
| <a name="input_replica_scale_cpu"></a> [replica\_scale\_cpu](#input\_replica\_scale\_cpu) | Needs to be set when predefined\_metric\_type is RDSReaderAverageCPUUtilization | `number` | n/a | yes |
| <a name="input_replica_scale_in_cooldown"></a> [replica\_scale\_in\_cooldown](#input\_replica\_scale\_in\_cooldown) | Cooldown in seconds before allowing further scaling operations after a scale in | `number` | n/a | yes |
| <a name="input_replica_scale_max"></a> [replica\_scale\_max](#input\_replica\_scale\_max) | Maximum number of replicas to scale up to | `number` | n/a | yes |
| <a name="input_replica_scale_min"></a> [replica\_scale\_min](#input\_replica\_scale\_min) | Minimum number of replicas to scale down to | `number` | n/a | yes |
| <a name="input_replica_scale_out_cooldown"></a> [replica\_scale\_out\_cooldown](#input\_replica\_scale\_out\_cooldown) | Cooldown in seconds before allowing further scaling operations after a scale out | `number` | n/a | yes |
| <a name="input_secondary_vpc_id"></a> [secondary\_vpc\_id](#input\_secondary\_vpc\_id) | The VPC ID of the secondary database cluster | `string` | n/a | yes |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Determines whether a final DB snapshot is created before the DB instance is deleted | `bool` | n/a | yes |
| <a name="input_storage_encrypted"></a> [storage\_encrypted](#input\_storage\_encrypted) | Specifies whether the DB cluster is encrypted | `bool` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resource | `map(any)` | n/a | yes |
| <a name="input_tcp_keepalives_count"></a> [tcp\_keepalives\_count](#input\_tcp\_keepalives\_count) | Maximum number of TCP keepalive retransmits.Specifies the number of TCP keepalive messages that can be lost before the server's connection to the client is considered dead. A value of 0 (the default) selects the operating system's default. | `number` | n/a | yes |
| <a name="input_tcp_keepalives_idle"></a> [tcp\_keepalives\_idle](#input\_tcp\_keepalives\_idle) | Time between issuing TCP keepalives.Specifies the amount of time with no network activity after which the operating system should send a TCP keepalive message to the client. If this value is specified without units, it is taken as seconds. A value of 0 (the default) selects the operating system's default. | `number` | n/a | yes |
| <a name="input_tcp_keepalives_interval"></a> [tcp\_keepalives\_interval](#input\_tcp\_keepalives\_interval) | Time between TCP keepalive retransmits. Specifies the amount of time after which a TCP keepalive message that has not been acknowledged by the client should be retransmitted. If this value is specified without units, it is taken as seconds. A value of 0 (the default) selects the operating system's default. | `number` | n/a | yes |
| <a name="input_username"></a> [username](#input\_username) | Username for the master DB user | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
