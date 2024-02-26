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
| [aws_iam_policy.awat-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.awat-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.awat-policy-attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_user.awat_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_s3_bucket.awat_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.awat_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_policy.awat_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.awat_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.awat_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_security_group.cnc_to_awat_db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_iam_policy_document.awat_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_kms_key.master_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [terraform_remote_state.cnc_cluster](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_awat_apply_immediately"></a> [awat\_apply\_immediately](#input\_awat\_apply\_immediately) | n/a | `bool` | `false` | no |
| <a name="input_awat_aurora_family"></a> [awat\_aurora\_family](#input\_awat\_aurora\_family) | n/a | `string` | `"aurora-postgresql13"` | no |
| <a name="input_awat_ca_cert_identifier"></a> [awat\_ca\_cert\_identifier](#input\_awat\_ca\_cert\_identifier) | Identifier of the CA certificate for the DB instance. | `string` | `"rds-ca-rsa4096-g1"` | no |
| <a name="input_awat_cluster_storage_encrypted"></a> [awat\_cluster\_storage\_encrypted](#input\_awat\_cluster\_storage\_encrypted) | n/a | `bool` | `true` | no |
| <a name="input_awat_copy_tags_to_snapshot"></a> [awat\_copy\_tags\_to\_snapshot](#input\_awat\_copy\_tags\_to\_snapshot) | n/a | `bool` | `true` | no |
| <a name="input_awat_db_backup_retention_period"></a> [awat\_db\_backup\_retention\_period](#input\_awat\_db\_backup\_retention\_period) | n/a | `number` | n/a | yes |
| <a name="input_awat_db_backup_window"></a> [awat\_db\_backup\_window](#input\_awat\_db\_backup\_window) | n/a | `string` | n/a | yes |
| <a name="input_awat_db_cluster_engine"></a> [awat\_db\_cluster\_engine](#input\_awat\_db\_cluster\_engine) | n/a | `string` | `"aurora-postgresql"` | no |
| <a name="input_awat_db_cluster_engine_mode"></a> [awat\_db\_cluster\_engine\_mode](#input\_awat\_db\_cluster\_engine\_mode) | n/a | `string` | `"provisioned"` | no |
| <a name="input_awat_db_cluster_engine_version"></a> [awat\_db\_cluster\_engine\_version](#input\_awat\_db\_cluster\_engine\_version) | n/a | `string` | `"13.7"` | no |
| <a name="input_awat_db_cluster_identifier"></a> [awat\_db\_cluster\_identifier](#input\_awat\_db\_cluster\_identifier) | n/a | `string` | n/a | yes |
| <a name="input_awat_db_cluster_instance_identifier"></a> [awat\_db\_cluster\_instance\_identifier](#input\_awat\_db\_cluster\_instance\_identifier) | n/a | `string` | n/a | yes |
| <a name="input_awat_db_cluster_instance_type"></a> [awat\_db\_cluster\_instance\_type](#input\_awat\_db\_cluster\_instance\_type) | n/a | `string` | `"db.serverless"` | no |
| <a name="input_awat_db_deletion_protection"></a> [awat\_db\_deletion\_protection](#input\_awat\_db\_deletion\_protection) | n/a | `bool` | `true` | no |
| <a name="input_awat_db_maintenance_window"></a> [awat\_db\_maintenance\_window](#input\_awat\_db\_maintenance\_window) | n/a | `string` | n/a | yes |
| <a name="input_awat_db_password"></a> [awat\_db\_password](#input\_awat\_db\_password) | n/a | `string` | n/a | yes |
| <a name="input_awat_db_username"></a> [awat\_db\_username](#input\_awat\_db\_username) | n/a | `string` | n/a | yes |
| <a name="input_awat_enable_rds_alerting"></a> [awat\_enable\_rds\_alerting](#input\_awat\_enable\_rds\_alerting) | n/a | `bool` | `false` | no |
| <a name="input_awat_enabled_cloudwatch_logs_exports"></a> [awat\_enabled\_cloudwatch\_logs\_exports](#input\_awat\_enabled\_cloudwatch\_logs\_exports) | n/a | `list(string)` | <pre>[<br>  "postgresql"<br>]</pre> | no |
| <a name="input_awat_kms_key"></a> [awat\_kms\_key](#input\_awat\_kms\_key) | n/a | `string` | n/a | yes |
| <a name="input_awat_max_capacity"></a> [awat\_max\_capacity](#input\_awat\_max\_capacity) | n/a | `number` | `4` | no |
| <a name="input_awat_min_capacity"></a> [awat\_min\_capacity](#input\_awat\_min\_capacity) | n/a | `number` | `0.5` | no |
| <a name="input_awat_monitoring_interval"></a> [awat\_monitoring\_interval](#input\_awat\_monitoring\_interval) | n/a | `number` | n/a | yes |
| <a name="input_awat_performance_insights_enabled"></a> [awat\_performance\_insights\_enabled](#input\_awat\_performance\_insights\_enabled) | n/a | `bool` | n/a | yes |
| <a name="input_awat_performance_insights_retention_period"></a> [awat\_performance\_insights\_retention\_period](#input\_awat\_performance\_insights\_retention\_period) | n/a | `number` | n/a | yes |
| <a name="input_awat_replica_min"></a> [awat\_replica\_min](#input\_awat\_replica\_min) | n/a | `number` | n/a | yes |
| <a name="input_awat_service_name"></a> [awat\_service\_name](#input\_awat\_service\_name) | n/a | `string` | `"awat"` | no |
| <a name="input_cloud_vpn_cidr"></a> [cloud\_vpn\_cidr](#input\_cloud\_vpn\_cidr) | n/a | `list(string)` | n/a | yes |
| <a name="input_enable_awat_bucket_restriction"></a> [enable\_awat\_bucket\_restriction](#input\_enable\_awat\_bucket\_restriction) | n/a | `bool` | n/a | yes |
| <a name="input_enable_awat_read_replica"></a> [enable\_awat\_read\_replica](#input\_enable\_awat\_read\_replica) | n/a | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace, which host the service account & target application | `string` | n/a | yes |
| <a name="input_open_oidc_provider_arn"></a> [open\_oidc\_provider\_arn](#input\_open\_oidc\_provider\_arn) | The Open OIDC Provider ARN for a specific cluster | `string` | n/a | yes |
| <a name="input_open_oidc_provider_url"></a> [open\_oidc\_provider\_url](#input\_open\_oidc\_provider\_url) | The Open OIDC Provider URL for a specific cluster | `string` | n/a | yes |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | n/a | `list(string)` | n/a | yes |
| <a name="input_serviceaccount"></a> [serviceaccount](#input\_serviceaccount) | Service Account, with which we want to associate IAM permission | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->