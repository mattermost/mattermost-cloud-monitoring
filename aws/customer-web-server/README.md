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
| <a name="module_aurora-cluster"></a> [aurora-cluster](#module\_aurora-cluster) | github.com/mattermost/mattermost-cloud-monitoring.git//aws/aurora-cluster | v1.7.93 |

## Resources

| Name | Type |
|------|------|
| [aws_db_subnet_group.cws_subnets_db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_security_group.cws_postgres_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.cws_calico_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_secretsmanager_secret.cws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret_version.cws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |
| [terraform_remote_state.cluster](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_major_version_upgrade"></a> [allow\_major\_version\_upgrade](#input\_allow\_major\_version\_upgrade) | Enable to allow major engine version upgrades when changing engine versions | `bool` | `false` | no |
| <a name="input_calico_cidr"></a> [calico\_cidr](#input\_calico\_cidr) | The Calico CIDR block to allow access | `list(string)` | `[]` | no |
| <a name="input_cloud_vpn_cidr"></a> [cloud\_vpn\_cidr](#input\_cloud\_vpn\_cidr) | n/a | `list(string)` | n/a | yes |
| <a name="input_connect_rds_ec2_security_group"></a> [connect\_rds\_ec2\_security\_group](#input\_connect\_rds\_ec2\_security\_group) | n/a | `string` | n/a | yes |
| <a name="input_cws_apply_immediately"></a> [cws\_apply\_immediately](#input\_cws\_apply\_immediately) | n/a | `bool` | `false` | no |
| <a name="input_cws_aurora_family"></a> [cws\_aurora\_family](#input\_cws\_aurora\_family) | n/a | `string` | `"aurora-postgresql14"` | no |
| <a name="input_cws_ca_cert_identifier"></a> [cws\_ca\_cert\_identifier](#input\_cws\_ca\_cert\_identifier) | Identifier of the CA certificate for the DB instance. | `string` | `"rds-ca-rsa4096-g1"` | no |
| <a name="input_cws_cluster_storage_encrypted"></a> [cws\_cluster\_storage\_encrypted](#input\_cws\_cluster\_storage\_encrypted) | n/a | `bool` | `true` | no |
| <a name="input_cws_copy_tags_to_snapshot"></a> [cws\_copy\_tags\_to\_snapshot](#input\_cws\_copy\_tags\_to\_snapshot) | n/a | `bool` | `true` | no |
| <a name="input_cws_db_backup_retention_period"></a> [cws\_db\_backup\_retention\_period](#input\_cws\_db\_backup\_retention\_period) | n/a | `number` | n/a | yes |
| <a name="input_cws_db_backup_window"></a> [cws\_db\_backup\_window](#input\_cws\_db\_backup\_window) | n/a | `string` | n/a | yes |
| <a name="input_cws_db_cluster_engine"></a> [cws\_db\_cluster\_engine](#input\_cws\_db\_cluster\_engine) | n/a | `string` | `"aurora-postgresql"` | no |
| <a name="input_cws_db_cluster_engine_mode"></a> [cws\_db\_cluster\_engine\_mode](#input\_cws\_db\_cluster\_engine\_mode) | n/a | `string` | `"provisioned"` | no |
| <a name="input_cws_db_cluster_engine_version"></a> [cws\_db\_cluster\_engine\_version](#input\_cws\_db\_cluster\_engine\_version) | n/a | `string` | `"14.10"` | no |
| <a name="input_cws_db_cluster_identifier"></a> [cws\_db\_cluster\_identifier](#input\_cws\_db\_cluster\_identifier) | n/a | `string` | n/a | yes |
| <a name="input_cws_db_cluster_instance_identifier"></a> [cws\_db\_cluster\_instance\_identifier](#input\_cws\_db\_cluster\_instance\_identifier) | n/a | `string` | n/a | yes |
| <a name="input_cws_db_cluster_instance_type"></a> [cws\_db\_cluster\_instance\_type](#input\_cws\_db\_cluster\_instance\_type) | n/a | `string` | `"db.serverless"` | no |
| <a name="input_cws_db_deletion_protection"></a> [cws\_db\_deletion\_protection](#input\_cws\_db\_deletion\_protection) | n/a | `bool` | `true` | no |
| <a name="input_cws_db_maintenance_window"></a> [cws\_db\_maintenance\_window](#input\_cws\_db\_maintenance\_window) | n/a | `string` | n/a | yes |
| <a name="input_cws_db_username"></a> [cws\_db\_username](#input\_cws\_db\_username) | n/a | `string` | n/a | yes |
| <a name="input_cws_enable_bastion"></a> [cws\_enable\_bastion](#input\_cws\_enable\_bastion) | n/a | `bool` | `true` | no |
| <a name="input_cws_enable_rds_alerting"></a> [cws\_enable\_rds\_alerting](#input\_cws\_enable\_rds\_alerting) | n/a | `bool` | `false` | no |
| <a name="input_cws_enabled_cloudwatch_logs_exports"></a> [cws\_enabled\_cloudwatch\_logs\_exports](#input\_cws\_enabled\_cloudwatch\_logs\_exports) | n/a | `list(string)` | <pre>[<br/>  "postgresql"<br/>]</pre> | no |
| <a name="input_cws_kms_key"></a> [cws\_kms\_key](#input\_cws\_kms\_key) | n/a | `string` | n/a | yes |
| <a name="input_cws_max_capacity"></a> [cws\_max\_capacity](#input\_cws\_max\_capacity) | n/a | `number` | `4` | no |
| <a name="input_cws_min_capacity"></a> [cws\_min\_capacity](#input\_cws\_min\_capacity) | n/a | `number` | `0.5` | no |
| <a name="input_cws_monitoring_interval"></a> [cws\_monitoring\_interval](#input\_cws\_monitoring\_interval) | n/a | `number` | n/a | yes |
| <a name="input_cws_performance_insights_enabled"></a> [cws\_performance\_insights\_enabled](#input\_cws\_performance\_insights\_enabled) | n/a | `bool` | n/a | yes |
| <a name="input_cws_performance_insights_retention_period"></a> [cws\_performance\_insights\_retention\_period](#input\_cws\_performance\_insights\_retention\_period) | n/a | `number` | n/a | yes |
| <a name="input_cws_replica_min"></a> [cws\_replica\_min](#input\_cws\_replica\_min) | n/a | `number` | n/a | yes |
| <a name="input_cws_service_name"></a> [cws\_service\_name](#input\_cws\_service\_name) | n/a | `string` | `"cws"` | no |
| <a name="input_enable_cws_read_replica"></a> [enable\_cws\_read\_replica](#input\_enable\_cws\_read\_replica) | n/a | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_iam_database_authentication_enabled"></a> [iam\_database\_authentication\_enabled](#input\_iam\_database\_authentication\_enabled) | Specifies whether or not mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled. | `bool` | `false` | no |
| <a name="input_is_calico_enabled"></a> [is\_calico\_enabled](#input\_is\_calico\_enabled) | Enable Calico network policies | `bool` | `false` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | n/a | `list(string)` | n/a | yes |
| <a name="input_teleport_cidr"></a> [teleport\_cidr](#input\_teleport\_cidr) | The Teleport CIDR block to allow access | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
