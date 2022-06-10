<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_aws.primary"></a> [aws.primary](#provider\_aws.primary) | n/a |
| <a name="provider_aws.secondary"></a> [aws.secondary](#provider\_aws.secondary) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_rds_cluster.primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster.secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster_instance.primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) | resource |
| [aws_rds_cluster_instance.secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) | resource |
| [aws_rds_global_cluster.global-cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_global_cluster) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | (Optional) The days to retain backups for. Default 1. | `number` | `1` | no |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | (Optional, Forces new resources) Name for an automatically created database on cluster creation. | `string` | n/a | yes |
| <a name="input_engine"></a> [engine](#input\_engine) | Name of the database engine to be used for this DB cluster. Terraform will only perform drift detection if a configuration value is provided. Valid values: aurora, aurora-mysql, aurora-postgresql. | `string` | n/a | yes |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Engine version of the Aurora global database. | `string` | n/a | yes |
| <a name="input_final_snapshot_identifier"></a> [final\_snapshot\_identifier](#input\_final\_snapshot\_identifier) | (Optional) The name of your final DB snapshot when this DB cluster is deleted. If omitted, no final snapshot will be made. | `string` | `"test-cluster-final"` | no |
| <a name="input_global_cluster_identifier"></a> [global\_cluster\_identifier](#input\_global\_cluster\_identifier) | (Required, Forces new resources) Global cluster identifier. | `string` | n/a | yes |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | instance class like db.r4.large etc. | `string` | n/a | yes |
| <a name="input_master_password"></a> [master\_password](#input\_master\_password) | Master password for rds cluster. | `string` | n/a | yes |
| <a name="input_master_username"></a> [master\_username](#input\_master\_username) | Master username for rds cluster. | `string` | n/a | yes |
| <a name="input_preferred_backup_window"></a> [preferred\_backup\_window](#input\_preferred\_backup\_window) | The daily time range during which automated backups are created if automated backups are enabled using the BackupRetentionPeriod parameter.Time in UTC. | `string` | `"03:00-05:00"` | no |
| <a name="input_primary_cluster_identifier"></a> [primary\_cluster\_identifier](#input\_primary\_cluster\_identifier) | Primary cluster identifier. | `string` | n/a | yes |
| <a name="input_primary_db_subnet_group_name"></a> [primary\_db\_subnet\_group\_name](#input\_primary\_db\_subnet\_group\_name) | db subnet group name. | `string` | `"default"` | no |
| <a name="input_primary_instances_count"></a> [primary\_instances\_count](#input\_primary\_instances\_count) | Specify number of primary instances. | `number` | `2` | no |
| <a name="input_secondary_cluster_identifier"></a> [secondary\_cluster\_identifier](#input\_secondary\_cluster\_identifier) | secondary cluster identifier. | `string` | n/a | yes |
| <a name="input_secondary_db_subnet_group_name"></a> [secondary\_db\_subnet\_group\_name](#input\_secondary\_db\_subnet\_group\_name) | db subnet group name. | `string` | `"default"` | no |
| <a name="input_secondary_instances_count"></a> [secondary\_instances\_count](#input\_secondary\_instances\_count) | Specify number of secondary instances. | `number` | `1` | no |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Determines whether a final DB snapshot is created before the DB cluster is deleted. | `bool` | `true` | no |
| <a name="input_source_region"></a> [source\_region](#input\_source\_region) | The source region for an encrypted replica DB cluster. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for Global Cluster & instances. | `map(string)` | `{}` | no |
| <a name="input_target_region"></a> [target\_region](#input\_target\_region) | TThe target region for an encrypted replica DB cluster. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->