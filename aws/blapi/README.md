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
| <a name="module_aurora-cluster"></a> [aurora-cluster](#module\_aurora-cluster) | github.com/mattermost/mattermost-cloud-monitoring.git//aws/aurora-cluster | v1.6.5 |

## Resources

| Name | Type |
|------|------|
| [aws_db_subnet_group.blapi_subnets_db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_iam_policy.pipelinewise-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_user.pipelinewise_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy_attachment.attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_s3_bucket.pipelinewise](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_object.snowflake_imports](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) | resource |
| [aws_security_group.blapi_cec_to_postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.connect-rds-ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_kms_key.master_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [terraform_remote_state.cluster](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_blapi_apply_immediately"></a> [blapi\_apply\_immediately](#input\_blapi\_apply\_immediately) | n/a | `bool` | `false` | no |
| <a name="input_blapi_aurora_family"></a> [blapi\_aurora\_family](#input\_blapi\_aurora\_family) | n/a | `string` | `"aurora-postgresql13"` | no |
| <a name="input_blapi_cluster_storage_encrypted"></a> [blapi\_cluster\_storage\_encrypted](#input\_blapi\_cluster\_storage\_encrypted) | n/a | `bool` | `true` | no |
| <a name="input_blapi_copy_tags_to_snapshot"></a> [blapi\_copy\_tags\_to\_snapshot](#input\_blapi\_copy\_tags\_to\_snapshot) | n/a | `bool` | `true` | no |
| <a name="input_blapi_db_cluster_engine"></a> [blapi\_db\_cluster\_engine](#input\_blapi\_db\_cluster\_engine) | n/a | `string` | `"aurora-postgresql"` | no |
| <a name="input_blapi_db_cluster_engine_mode"></a> [blapi\_db\_cluster\_engine\_mode](#input\_blapi\_db\_cluster\_engine\_mode) | n/a | `string` | `"provisioned"` | no |
| <a name="input_blapi_db_cluster_engine_version"></a> [blapi\_db\_cluster\_engine\_version](#input\_blapi\_db\_cluster\_engine\_version) | n/a | `string` | `"13.8"` | no |
| <a name="input_blapi_db_cluster_identifier"></a> [blapi\_db\_cluster\_identifier](#input\_blapi\_db\_cluster\_identifier) | n/a | `string` | n/a | yes |
| <a name="input_blapi_db_cluster_instance_identifier"></a> [blapi\_db\_cluster\_instance\_identifier](#input\_blapi\_db\_cluster\_instance\_identifier) | n/a | `string` | n/a | yes |
| <a name="input_blapi_db_cluster_instance_type"></a> [blapi\_db\_cluster\_instance\_type](#input\_blapi\_db\_cluster\_instance\_type) | n/a | `string` | `"db.t4g.medium"` | no |
| <a name="input_blapi_enabled_cloudwatch_logs_exports"></a> [blapi\_enabled\_cloudwatch\_logs\_exports](#input\_blapi\_enabled\_cloudwatch\_logs\_exports) | n/a | `list(string)` | <pre>[<br>  "postgresql"<br>]</pre> | no |
| <a name="input_blapi_kms_key"></a> [blapi\_kms\_key](#input\_blapi\_kms\_key) | n/a | `string` | n/a | yes |
| <a name="input_blapi_max_capacity"></a> [blapi\_max\_capacity](#input\_blapi\_max\_capacity) | n/a | `number` | `4` | no |
| <a name="input_blapi_min_capacity"></a> [blapi\_min\_capacity](#input\_blapi\_min\_capacity) | n/a | `number` | `0.5` | no |
| <a name="input_blapi_monitoring_interval"></a> [blapi\_monitoring\_interval](#input\_blapi\_monitoring\_interval) | n/a | `number` | n/a | yes |
| <a name="input_blapi_performance_insights_enabled"></a> [blapi\_performance\_insights\_enabled](#input\_blapi\_performance\_insights\_enabled) | n/a | `bool` | n/a | yes |
| <a name="input_blapi_performance_insights_retention_period"></a> [blapi\_performance\_insights\_retention\_period](#input\_blapi\_performance\_insights\_retention\_period) | n/a | `number` | `7` | no |
| <a name="input_blapi_replica_min"></a> [blapi\_replica\_min](#input\_blapi\_replica\_min) | n/a | `number` | n/a | yes |
| <a name="input_blapi_service_name"></a> [blapi\_service\_name](#input\_blapi\_service\_name) | n/a | `string` | `"blapi"` | no |
| <a name="input_cloud_vpn_cidr"></a> [cloud\_vpn\_cidr](#input\_cloud\_vpn\_cidr) | n/a | `list(string)` | n/a | yes |
| <a name="input_connect_ec2_rds_security_group"></a> [connect\_ec2\_rds\_security\_group](#input\_connect\_ec2\_rds\_security\_group) | n/a | `string` | n/a | yes |
| <a name="input_db_backup_retention_period"></a> [db\_backup\_retention\_period](#input\_db\_backup\_retention\_period) | n/a | `number` | n/a | yes |
| <a name="input_db_backup_window"></a> [db\_backup\_window](#input\_db\_backup\_window) | n/a | `string` | n/a | yes |
| <a name="input_db_deletion_protection"></a> [db\_deletion\_protection](#input\_db\_deletion\_protection) | n/a | `bool` | `true` | no |
| <a name="input_db_maintenance_window"></a> [db\_maintenance\_window](#input\_db\_maintenance\_window) | n/a | `string` | n/a | yes |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | n/a | `string` | n/a | yes |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | n/a | `string` | n/a | yes |
| <a name="input_enable_blapi_read_replica"></a> [enable\_blapi\_read\_replica](#input\_enable\_blapi\_read\_replica) | n/a | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_kms_key"></a> [kms\_key](#input\_kms\_key) | n/a | `string` | n/a | yes |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | n/a | `list(string)` | n/a | yes |
| <a name="input_provider_role_arn"></a> [provider\_role\_arn](#input\_provider\_role\_arn) | n/a | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | The AWS region which will be used. | `string` | n/a | yes |
| <a name="input_snowflake_imports"></a> [snowflake\_imports](#input\_snowflake\_imports) | n/a | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
