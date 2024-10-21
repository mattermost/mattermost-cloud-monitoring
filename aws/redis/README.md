<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_cidrs"></a> [allowed\_cidrs](#input\_allowed\_cidrs) | CIDR blocks allowed to access the Redis cluster | `list(string)` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type for the Redis nodes | `string` | `"cache.t2.micro"` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the ElastiCache Redis cluster | `string` | n/a | yes |
| <a name="input_num_cache_nodes"></a> [num\_cache\_nodes](#input\_num\_cache\_nodes) | Number of cache nodes in the Redis cluster | `number` | `1` | no |
| <a name="input_parameter_group_name"></a> [parameter\_group\_name](#input\_parameter\_group\_name) | Parameter group name to use for Redis | `string` | `"default.redis7"` | no |
| <a name="input_port"></a> [port](#input\_port) | Port for Redis | `number` | `6379` | no |
| <a name="input_redis_version"></a> [redis\_version](#input\_redis\_version) | The Redis version to use | `string` | `"7.1"` | no |
| <a name="input_region"></a> [region](#input\_region) | The AWS region to deploy resources in | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs for the Redis cluster | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID where the ElastiCache Redis will be deployed | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->