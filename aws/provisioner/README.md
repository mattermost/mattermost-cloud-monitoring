<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.61.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.61.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aurora-cluster"></a> [aurora-cluster](#module\_aurora-cluster) | github.com/mattermost/mattermost-cloud-monitoring.git//aws/aurora-cluster | v1.6.63 |

## Resources

| Name | Type |
|------|------|
| [aws_db_subnet_group.subnets_db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_iam_access_key.provisioner_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_security_group.cec_to_postgress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [terraform_remote_state.cluster](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_vpn_cidr"></a> [cloud\_vpn\_cidr](#input\_cloud\_vpn\_cidr) | n/a | `list(string)` | n/a | yes |
| <a name="input_db_backup_retention_period"></a> [db\_backup\_retention\_period](#input\_db\_backup\_retention\_period) | n/a | `string` | n/a | yes |
| <a name="input_db_backup_window"></a> [db\_backup\_window](#input\_db\_backup\_window) | n/a | `string` | n/a | yes |
| <a name="input_db_deletion_protection"></a> [db\_deletion\_protection](#input\_db\_deletion\_protection) | n/a | `bool` | `true` | no |
| <a name="input_db_maintenance_window"></a> [db\_maintenance\_window](#input\_db\_maintenance\_window) | n/a | `string` | n/a | yes |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | n/a | `string` | n/a | yes |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | n/a | `string` | n/a | yes |
| <a name="input_enable_provisioner_read_replica"></a> [enable\_provisioner\_read\_replica](#input\_enable\_provisioner\_read\_replica) | n/a | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_gitlab_cidr"></a> [gitlab\_cidr](#input\_gitlab\_cidr) | The gitlab CIDR | `list(any)` | n/a | yes |
| <a name="input_grafana_cidr"></a> [grafana\_cidr](#input\_grafana\_cidr) | The centralised CIDR | `list(any)` | n/a | yes |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | n/a | `list(string)` | n/a | yes |
| <a name="input_provider_role_arn"></a> [provider\_role\_arn](#input\_provider\_role\_arn) | n/a | `string` | `""` | no |
| <a name="input_provisioner_apply_immediately"></a> [provisioner\_apply\_immediately](#input\_provisioner\_apply\_immediately) | n/a | `bool` | `false` | no |
| <a name="input_provisioner_aurora_family"></a> [provisioner\_aurora\_family](#input\_provisioner\_aurora\_family) | n/a | `string` | `"aurora-postgresql13"` | no |
| <a name="input_provisioner_ca_cert_identifier"></a> [provisioner\_ca\_cert\_identifier](#input\_provisioner\_ca\_cert\_identifier) | Identifier of the CA certificate for the DB instance. | `string` | `"rds-ca-rsa4096-g1"` | no |
| <a name="input_provisioner_cluster_storage_encrypted"></a> [provisioner\_cluster\_storage\_encrypted](#input\_provisioner\_cluster\_storage\_encrypted) | n/a | `bool` | `true` | no |
| <a name="input_provisioner_copy_tags_to_snapshot"></a> [provisioner\_copy\_tags\_to\_snapshot](#input\_provisioner\_copy\_tags\_to\_snapshot) | n/a | `bool` | `true` | no |
| <a name="input_provisioner_db_cluster_engine"></a> [provisioner\_db\_cluster\_engine](#input\_provisioner\_db\_cluster\_engine) | n/a | `string` | `"aurora-postgresql"` | no |
| <a name="input_provisioner_db_cluster_engine_mode"></a> [provisioner\_db\_cluster\_engine\_mode](#input\_provisioner\_db\_cluster\_engine\_mode) | n/a | `string` | `"provisioned"` | no |
| <a name="input_provisioner_db_cluster_engine_version"></a> [provisioner\_db\_cluster\_engine\_version](#input\_provisioner\_db\_cluster\_engine\_version) | n/a | `string` | `"13.8"` | no |
| <a name="input_provisioner_db_cluster_identifier"></a> [provisioner\_db\_cluster\_identifier](#input\_provisioner\_db\_cluster\_identifier) | n/a | `string` | n/a | yes |
| <a name="input_provisioner_db_cluster_instance_identifier"></a> [provisioner\_db\_cluster\_instance\_identifier](#input\_provisioner\_db\_cluster\_instance\_identifier) | n/a | `string` | n/a | yes |
| <a name="input_provisioner_db_cluster_instance_type"></a> [provisioner\_db\_cluster\_instance\_type](#input\_provisioner\_db\_cluster\_instance\_type) | n/a | `string` | `"db.serverless"` | no |
| <a name="input_provisioner_enable_rds_alerting"></a> [provisioner\_enable\_rds\_alerting](#input\_provisioner\_enable\_rds\_alerting) | n/a | `bool` | `false` | no |
| <a name="input_provisioner_enabled_cloudwatch_logs_exports"></a> [provisioner\_enabled\_cloudwatch\_logs\_exports](#input\_provisioner\_enabled\_cloudwatch\_logs\_exports) | n/a | `list(string)` | <pre>[<br>  "postgresql"<br>]</pre> | no |
| <a name="input_provisioner_kms_key"></a> [provisioner\_kms\_key](#input\_provisioner\_kms\_key) | n/a | `string` | n/a | yes |
| <a name="input_provisioner_max_capacity"></a> [provisioner\_max\_capacity](#input\_provisioner\_max\_capacity) | n/a | `number` | `4` | no |
| <a name="input_provisioner_min_capacity"></a> [provisioner\_min\_capacity](#input\_provisioner\_min\_capacity) | n/a | `number` | `0.5` | no |
| <a name="input_provisioner_monitoring_interval"></a> [provisioner\_monitoring\_interval](#input\_provisioner\_monitoring\_interval) | n/a | `number` | n/a | yes |
| <a name="input_provisioner_performance_insights_enabled"></a> [provisioner\_performance\_insights\_enabled](#input\_provisioner\_performance\_insights\_enabled) | n/a | `bool` | n/a | yes |
| <a name="input_provisioner_performance_insights_retention_period"></a> [provisioner\_performance\_insights\_retention\_period](#input\_provisioner\_performance\_insights\_retention\_period) | n/a | `number` | n/a | yes |
| <a name="input_provisioner_replica_min"></a> [provisioner\_replica\_min](#input\_provisioner\_replica\_min) | n/a | `number` | n/a | yes |
| <a name="input_provisioner_service_name"></a> [provisioner\_service\_name](#input\_provisioner\_service\_name) | n/a | `string` | `"provisioner"` | no |
| <a name="input_provisioner_users"></a> [provisioner\_users](#input\_provisioner\_users) | n/a | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->