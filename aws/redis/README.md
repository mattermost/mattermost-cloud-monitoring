## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.70.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.70.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_elasticache_cluster.redis_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_elasticache_subnet_group.redis_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_security_group.redis_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_cidrs"></a> [allowed\_cidrs](#input\_allowed\_cidrs) | CIDR blocks allowed to access the Redis cluster | `list(string)` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type for the Redis nodes | `string` | `"cache.t2.micro"` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the ElastiCache Redis cluster | `string` | n/a | yes |
| <a name="input_num_cache_nodes"></a> [num\_cache\_nodes](#input\_num\_cache\_nodes) | Number of cache nodes in the Redis cluster | `number` | `1` | no |
| <a name="input_port"></a> [port](#input\_port) | Port for Redis | `number` | `6379` | no |
| <a name="input_redis_version"></a> [redis\_version](#input\_redis\_version) | The Redis version to use | `string` | `"7.1"` | no |
| <a name="input_region"></a> [region](#input\_region) | The AWS region to deploy resources in | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs for the Redis cluster | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID where the ElastiCache Redis will be deployed | `string` | n/a | yes |

## Outputs

No outputs.
