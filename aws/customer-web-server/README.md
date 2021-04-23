## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.cws_postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_instance.cws_postgres_read_replica](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_subnet_group.cws_subnets_db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_security_group.cws_postgres_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [terraform_remote_state.cluster](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_vpn_cidr"></a> [cloud\_vpn\_cidr](#input\_cloud\_vpn\_cidr) | n/a | `any` | n/a | yes |
| <a name="input_cws_allocated_db_storage"></a> [cws\_allocated\_db\_storage](#input\_cws\_allocated\_db\_storage) | n/a | `any` | n/a | yes |
| <a name="input_cws_db_backup_retention_period"></a> [cws\_db\_backup\_retention\_period](#input\_cws\_db\_backup\_retention\_period) | n/a | `any` | n/a | yes |
| <a name="input_cws_db_backup_window"></a> [cws\_db\_backup\_window](#input\_cws\_db\_backup\_window) | n/a | `any` | n/a | yes |
| <a name="input_cws_db_engine_version"></a> [cws\_db\_engine\_version](#input\_cws\_db\_engine\_version) | n/a | `any` | n/a | yes |
| <a name="input_cws_db_identifier"></a> [cws\_db\_identifier](#input\_cws\_db\_identifier) | n/a | `any` | n/a | yes |
| <a name="input_cws_db_instance_class"></a> [cws\_db\_instance\_class](#input\_cws\_db\_instance\_class) | n/a | `any` | n/a | yes |
| <a name="input_cws_db_maintenance_window"></a> [cws\_db\_maintenance\_window](#input\_cws\_db\_maintenance\_window) | n/a | `any` | n/a | yes |
| <a name="input_cws_db_master_az"></a> [cws\_db\_master\_az](#input\_cws\_db\_master\_az) | n/a | `any` | n/a | yes |
| <a name="input_cws_db_name"></a> [cws\_db\_name](#input\_cws\_db\_name) | n/a | `any` | n/a | yes |
| <a name="input_cws_db_password"></a> [cws\_db\_password](#input\_cws\_db\_password) | n/a | `any` | n/a | yes |
| <a name="input_cws_db_read_replica_az"></a> [cws\_db\_read\_replica\_az](#input\_cws\_db\_read\_replica\_az) | n/a | `any` | n/a | yes |
| <a name="input_cws_db_username"></a> [cws\_db\_username](#input\_cws\_db\_username) | n/a | `any` | n/a | yes |
| <a name="input_cws_storage_encrypted"></a> [cws\_storage\_encrypted](#input\_cws\_storage\_encrypted) | n/a | `any` | n/a | yes |
| <a name="input_enable_cws_read_replica"></a> [enable\_cws\_read\_replica](#input\_enable\_cws\_read\_replica) | n/a | `any` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `any` | n/a | yes |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | n/a | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `any` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `any` | n/a | yes |

## Outputs

No outputs.
