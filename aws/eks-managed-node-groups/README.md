## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.41.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.20 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.41.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eks_node_group.calico_arm_nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_eks_node_group.general_arm_nodes_eks_cluster_ng](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_eks_node_group.general_nodes_eks_cluster_ng](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_eks_node_group.spot_nodes_eks_cluster_ng](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_launch_template.calico_cluster_nodes_eks_arm_launch_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_launch_template.cluster_nodes_eks_arm_launch_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_launch_template.cluster_nodes_eks_launch_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_launch_template.cluster_spot_nodes_eks_launch_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_al2023_ami_id"></a> [al2023\_ami\_id](#input\_al2023\_ami\_id) | The AMI ID for AL2023 nodes | `string` | `""` | no |
| <a name="input_al2023_arm_image_id"></a> [al2023\_arm\_image\_id](#input\_al2023\_arm\_image\_id) | The AMI ID for ARM64 nodes using AL2023 | `string` | `""` | no |
| <a name="input_api_server_endpoint"></a> [api\_server\_endpoint](#input\_api\_server\_endpoint) | The API server endpoint for the EKS cluster | `string` | n/a | yes |
| <a name="input_arm_desired_size"></a> [arm\_desired\_size](#input\_arm\_desired\_size) | The desired number of arm nodes in the node group | `string` | n/a | yes |
| <a name="input_arm_image_id"></a> [arm\_image\_id](#input\_arm\_image\_id) | The AMI ID used for the nodes in the node group | `string` | n/a | yes |
| <a name="input_arm_instance_type"></a> [arm\_instance\_type](#input\_arm\_instance\_type) | The instance type used for the arm nodes in the node group | `string` | n/a | yes |
| <a name="input_arm_max_size"></a> [arm\_max\_size](#input\_arm\_max\_size) | The maximum number of arm nodes in the node group | `string` | n/a | yes |
| <a name="input_arm_min_size"></a> [arm\_min\_size](#input\_arm\_min\_size) | The minimum number of arm nodes in the node group | `string` | n/a | yes |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of availability zones to place the instances | `list(string)` | n/a | yes |
| <a name="input_calico_desired_size"></a> [calico\_desired\_size](#input\_calico\_desired\_size) | Desired size for the Calico node group | `number` | `3` | no |
| <a name="input_calico_max_pods"></a> [calico\_max\_pods](#input\_calico\_max\_pods) | Maximum number of pods when Calico CNI is enabled | `number` | `110` | no |
| <a name="input_calico_max_size"></a> [calico\_max\_size](#input\_calico\_max\_size) | Maximum size for the Calico node group | `number` | `5` | no |
| <a name="input_calico_min_size"></a> [calico\_min\_size](#input\_calico\_min\_size) | Minimum size for the Calico node group | `number` | `2` | no |
| <a name="input_certificate_authority"></a> [certificate\_authority](#input\_certificate\_authority) | The certificate authority data for the EKS cluster | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the cluster that the node group will be assigned to | `string` | n/a | yes |
| <a name="input_cluster_short_name"></a> [cluster\_short\_name](#input\_cluster\_short\_name) | A short name that identifies the cluster | `string` | n/a | yes |
| <a name="input_deployment_name"></a> [deployment\_name](#input\_deployment\_name) | A phrase that can be used for tagging tha identifies the deployment | `string` | n/a | yes |
| <a name="input_desired_size"></a> [desired\_size](#input\_desired\_size) | The desired number of nodes in the node group | `string` | n/a | yes |
| <a name="input_ebs_optimized"></a> [ebs\_optimized](#input\_ebs\_optimized) | If true, the launched EC2 instance will be EBS-optimized | `bool` | `null` | no |
| <a name="input_enable_spot_nodes"></a> [enable\_spot\_nodes](#input\_enable\_spot\_nodes) | If true, spot nodes will be created | `bool` | `false` | no |
| <a name="input_image_id"></a> [image\_id](#input\_image\_id) | The AMI ID used for the nodes in the node group | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type used for the nodes in the node group | `string` | n/a | yes |
| <a name="input_instance_type_max_pods_map"></a> [instance\_type\_max\_pods\_map](#input\_instance\_type\_max\_pods\_map) | Map of instance types to their maximum pod limits for AWS VPC CNI | `map(number)` | <pre>{<br/>  "c6g.12xlarge": 234,<br/>  "c6g.16xlarge": 737,<br/>  "c6g.2xlarge": 58,<br/>  "c6g.4xlarge": 234,<br/>  "c6g.8xlarge": 234,<br/>  "c6g.large": 35,<br/>  "c6g.medium": 17,<br/>  "c6g.metal": 737,<br/>  "c6g.xlarge": 58,<br/>  "c6gd.12xlarge": 234,<br/>  "c6gd.16xlarge": 737,<br/>  "c6gd.2xlarge": 58,<br/>  "c6gd.4xlarge": 234,<br/>  "c6gd.8xlarge": 234,<br/>  "c6gd.large": 35,<br/>  "c6gd.medium": 17,<br/>  "c6gd.metal": 737,<br/>  "c6gd.xlarge": 58,<br/>  "m6g.12xlarge": 234,<br/>  "m6g.16xlarge": 737,<br/>  "m6g.2xlarge": 58,<br/>  "m6g.4xlarge": 234,<br/>  "m6g.8xlarge": 234,<br/>  "m6g.large": 35,<br/>  "m6g.medium": 17,<br/>  "m6g.metal": 737,<br/>  "m6g.xlarge": 58,<br/>  "m6gd.12xlarge": 234,<br/>  "m6gd.16xlarge": 737,<br/>  "m6gd.2xlarge": 58,<br/>  "m6gd.4xlarge": 234,<br/>  "m6gd.8xlarge": 234,<br/>  "m6gd.large": 35,<br/>  "m6gd.medium": 17,<br/>  "m6gd.metal": 737,<br/>  "m6gd.xlarge": 58,<br/>  "r6g.12xlarge": 234,<br/>  "r6g.16xlarge": 737,<br/>  "r6g.2xlarge": 58,<br/>  "r6g.4xlarge": 234,<br/>  "r6g.8xlarge": 234,<br/>  "r6g.large": 35,<br/>  "r6g.medium": 17,<br/>  "r6g.metal": 737,<br/>  "r6g.xlarge": 58,<br/>  "r6gd.12xlarge": 234,<br/>  "r6gd.16xlarge": 737,<br/>  "r6gd.2xlarge": 58,<br/>  "r6gd.4xlarge": 234,<br/>  "r6gd.8xlarge": 234,<br/>  "r6gd.large": 35,<br/>  "r6gd.medium": 17,<br/>  "r6gd.metal": 737,<br/>  "r6gd.xlarge": 58,<br/>  "t4g.2xlarge": 58,<br/>  "t4g.large": 35,<br/>  "t4g.medium": 17,<br/>  "t4g.micro": 4,<br/>  "t4g.nano": 4,<br/>  "t4g.small": 11,<br/>  "t4g.xlarge": 58<br/>}</pre> | no |
| <a name="input_is_calico_enabled"></a> [is\_calico\_enabled](#input\_is\_calico\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | The maximum number of nodes in the node group | `string` | n/a | yes |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | The minimum number of nodes in the node group | `string` | n/a | yes |
| <a name="input_node_group_name"></a> [node\_group\_name](#input\_node\_group\_name) | A name that can be used to identify the node group | `string` | n/a | yes |
| <a name="input_node_role_arn"></a> [node\_role\_arn](#input\_node\_role\_arn) | The ARN of the IAM role attached to the node group | `string` | n/a | yes |
| <a name="input_service_ipv4_cidr"></a> [service\_ipv4\_cidr](#input\_service\_ipv4\_cidr) | The service IPv4 CIDR range for the EKS cluster | `string` | n/a | yes |
| <a name="input_spot_desired_size"></a> [spot\_desired\_size](#input\_spot\_desired\_size) | The desired number of nodes in the spot node group | `number` | `0` | no |
| <a name="input_spot_instance_type"></a> [spot\_instance\_type](#input\_spot\_instance\_type) | The instance type used for the nodes in the spot node group | `string` | n/a | yes |
| <a name="input_spot_max_size"></a> [spot\_max\_size](#input\_spot\_max\_size) | The maximum number of nodes in the spot node group | `number` | `1` | no |
| <a name="input_spot_min_size"></a> [spot\_min\_size](#input\_spot\_min\_size) | The minimum number of nodes in the spot node group | `number` | `0` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of Subnet IDs that nodes will be deployed into | `list(string)` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Map of availability zones and their subnets | `map(any)` | n/a | yes |
| <a name="input_use_al2023"></a> [use\_al2023](#input\_use\_al2023) | Enable AL2023-specific configurations. Defaults to false for AL2. | `bool` | `false` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | User data passed in the launch template to run in instance boot | `string` | n/a | yes |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | The size of the node volumes | `string` | n/a | yes |
| <a name="input_volume_type"></a> [volume\_type](#input\_volume\_type) | The type of the node volumes. For example gp2 | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID to use for the EKS cluster | `string` | n/a | yes |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | The IDs of the security groups that will be assigned to the cluster nodes | `list(string)` | n/a | yes |

## Outputs

No outputs.
