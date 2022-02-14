## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eks_node_group.general_nodes_eks_cluster_ng](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_eks_node_group.spot_nodes_eks_cluster_ng](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_launch_template.cluster_nodes_eks_launch_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_launch_template.cluster_spot_nodes_eks_launch_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the cluster that the node group will be assigned to | `any` | n/a | yes |
| <a name="input_cluster_short_name"></a> [cluster\_short\_name](#input\_cluster\_short\_name) | A short name that identifies the cluster | `any` | n/a | yes |
| <a name="input_deployment_name"></a> [deployment\_name](#input\_deployment\_name) | A phrase that can be used for tagging tha identifies the deployment | `any` | n/a | yes |
| <a name="input_desired_size"></a> [desired\_size](#input\_desired\_size) | The desired number of nodes in the node group | `any` | n/a | yes |
| <a name="input_image_id"></a> [image\_id](#input\_image\_id) | The AMI ID used for the nodes in the node group | `any` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type used for the nodes in the node group | `any` | n/a | yes |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | The maximum number of nodes in the node group | `any` | n/a | yes |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | The minimum number of nodes in the node group | `any` | n/a | yes |
| <a name="input_node_group_name"></a> [node\_group\_name](#input\_node\_group\_name) | A name that can be used to identify the node group | `any` | n/a | yes |
| <a name="input_node_role_arn"></a> [node\_role\_arn](#input\_node\_role\_arn) | The ARN of the IAM role attached to the node group | `any` | n/a | yes |
| <a name="input_spot_desired_size"></a> [spot\_desired\_size](#input\_spot\_desired\_size) | The desired number of nodes in the spot node group | `number` | `0` | no |
| <a name="input_spot_instance_type"></a> [spot\_instance\_type](#input\_spot\_instance\_type) | The instance type used for the nodes in the spot node group | `string` | n/a | yes |
| <a name="input_spot_max_size"></a> [spot\_max\_size](#input\_spot\_max\_size) | The maximum number of nodes in the spot node group | `number` | `1` | no |
| <a name="input_spot_min_size"></a> [spot\_min\_size](#input\_spot\_min\_size) | The minimum number of nodes in the spot node group | `number` | `0` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of Subnet IDs that nodes will be deployed into | `any` | n/a | yes |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | User data passed in the launch template to run in instance boot | `any` | n/a | yes |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | The size of the node volumes | `any` | n/a | yes |
| <a name="input_volume_type"></a> [volume\_type](#input\_volume\_type) | The type of the node volumes. For example gp2 | `any` | n/a | yes |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | The IDs of the security groups that will be assigned to the cluster nodes | `any` | n/a | yes |

## Outputs

No outputs.
