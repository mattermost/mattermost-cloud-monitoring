## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.41.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.0 |
| <a name="requirement_http"></a> [http](#requirement\_http) | ~> 2.2 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.20 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.5.1 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.2.2 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.41.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.20 |
| <a name="provider_local"></a> [local](#provider\_local) | >= 2.5.1 |
| <a name="provider_null"></a> [null](#provider\_null) | >= 3.2.2 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | >= 4.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_managed_node_group"></a> [managed\_node\_group](#module\_managed\_node\_group) | github.com/mattermost/mattermost-cloud-monitoring.git//aws/eks-managed-node-groups | v1.8.44 |

## Resources

| Name | Type |
|------|------|
| [aws_eks_addon.coredns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.ebs_csi](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.kube_proxy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.vpc_cni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_iam_instance_profile.worker-instance-profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_openid_connect_provider.eks_cluster_openid_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_policy.kube2iam-eks-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.worker_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.argocd-deployer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.cluster-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.worker-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.amazon_ec2_container_registry_readonly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.amazon_eks_worker_node_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.amazons_eks_cni_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.cluster-AmazonEKSCNIPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.cluster-AmazonEKSServicePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.kube2iam-policy-attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.worker-AmazonEC2ContainerRegistryReadOnly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.worker-AmazonEKSWorkerNodePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.worker-AmazonEKS_CNI_Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.worker-AmazonEKS_EBS_CSI_Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.worker_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_secretsmanager_secret.kubeconfig_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.kubeconfig_secret_version](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.cluster-sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.worker-sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.cluster-ingress-workstation-https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.master-gitlab](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.master-teleport](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.worker-ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.worker-sg-ingress-cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.worker-sg-ingress-self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.worker-teleport](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [kubernetes_cluster_role.console_access](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.read_only_access](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role_binding.console_access](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_cluster_role_binding.read_only_access](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_config_map.aws_auth_configmap](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_storage_class_v1.gp3](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/storage_class_v1) | resource |
| [local_file.kubeconfig](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.calico_operator_configuration](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.install_calico_operator](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.patch_aws_node](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.patch_calico_daemonset](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_role.lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [tls_certificate.cluster_openid_issuer](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_al2023_ami_id"></a> [al2023\_ami\_id](#input\_al2023\_ami\_id) | The AMI ID for AL2023 nodes | `string` | `""` | no |
| <a name="input_al2023_arm_image_id"></a> [al2023\_arm\_image\_id](#input\_al2023\_arm\_image\_id) | The AMI ID for ARM64 nodes using AL2023 | `string` | `""` | no |
| <a name="input_argocd_account_role"></a> [argocd\_account\_role](#input\_argocd\_account\_role) | n/a | `string` | n/a | yes |
| <a name="input_arm_desired_size"></a> [arm\_desired\_size](#input\_arm\_desired\_size) | The desired number of arm nodes in the node group | `string` | n/a | yes |
| <a name="input_arm_instance_type"></a> [arm\_instance\_type](#input\_arm\_instance\_type) | The instance type used for the arm nodes in the node group | `string` | n/a | yes |
| <a name="input_arm_max_size"></a> [arm\_max\_size](#input\_arm\_max\_size) | The maximum number of arm nodes in the node group | `string` | n/a | yes |
| <a name="input_arm_min_size"></a> [arm\_min\_size](#input\_arm\_min\_size) | The minimum number of arm nodes in the node group | `string` | n/a | yes |
| <a name="input_atlantis_user"></a> [atlantis\_user](#input\_atlantis\_user) | The atlantis user used for IaC | `string` | n/a | yes |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of availability zones to place the instances | `list(string)` | n/a | yes |
| <a name="input_aws_read_only_sso_role_name"></a> [aws\_read\_only\_sso\_role\_name](#input\_aws\_read\_only\_sso\_role\_name) | Name of the read only SSO iam role | `string` | `""` | no |
| <a name="input_aws_reserved_sso_id"></a> [aws\_reserved\_sso\_id](#input\_aws\_reserved\_sso\_id) | n/a | `string` | n/a | yes |
| <a name="input_calico_desired_size"></a> [calico\_desired\_size](#input\_calico\_desired\_size) | Desired size for the Calico node group | `number` | `3` | no |
| <a name="input_calico_max_size"></a> [calico\_max\_size](#input\_calico\_max\_size) | Maximum size for the Calico node group | `number` | `5` | no |
| <a name="input_calico_min_size"></a> [calico\_min\_size](#input\_calico\_min\_size) | Minimum size for the Calico node group | `number` | `2` | no |
| <a name="input_calico_operator_version"></a> [calico\_operator\_version](#input\_calico\_operator\_version) | n/a | `string` | `"v3.29.2"` | no |
| <a name="input_cidr_blocks"></a> [cidr\_blocks](#input\_cidr\_blocks) | n/a | `list(string)` | n/a | yes |
| <a name="input_cluster_short_name"></a> [cluster\_short\_name](#input\_cluster\_short\_name) | n/a | `string` | n/a | yes |
| <a name="input_coredns_addon_version"></a> [coredns\_addon\_version](#input\_coredns\_addon\_version) | The version of the EKS CoreDNS addon | `string` | n/a | yes |
| <a name="input_deployment_name"></a> [deployment\_name](#input\_deployment\_name) | n/a | `string` | n/a | yes |
| <a name="input_desired_size"></a> [desired\_size](#input\_desired\_size) | n/a | `string` | n/a | yes |
| <a name="input_ebs_csi_addon_version"></a> [ebs\_csi\_addon\_version](#input\_ebs\_csi\_addon\_version) | The version of the EKS EBS CSI addon | `string` | n/a | yes |
| <a name="input_ebs_optimized"></a> [ebs\_optimized](#input\_ebs\_optimized) | If true, the launched EC2 instance will be EBS-optimized | `bool` | `null` | no |
| <a name="input_eks_ami_id"></a> [eks\_ami\_id](#input\_eks\_ami\_id) | n/a | `string` | n/a | yes |
| <a name="input_eks_arm_image_id"></a> [eks\_arm\_image\_id](#input\_eks\_arm\_image\_id) | The AMI ID used for the arm nodes in the node group | `string` | n/a | yes |
| <a name="input_enable_coredns_addon"></a> [enable\_coredns\_addon](#input\_enable\_coredns\_addon) | Whether to enable the EKS CoreDNS addon or not | `bool` | n/a | yes |
| <a name="input_enable_ebs_csi_addon"></a> [enable\_ebs\_csi\_addon](#input\_enable\_ebs\_csi\_addon) | Whether to enable the EKS EBS CSI addon or not | `bool` | n/a | yes |
| <a name="input_enable_kube_proxy_addon"></a> [enable\_kube\_proxy\_addon](#input\_enable\_kube\_proxy\_addon) | Whether to enable the EKS Kube Proxy addon or not | `bool` | n/a | yes |
| <a name="input_enable_spot_nodes"></a> [enable\_spot\_nodes](#input\_enable\_spot\_nodes) | If true, spot nodes will be created | `bool` | `false` | no |
| <a name="input_enable_vpc_cni_addon"></a> [enable\_vpc\_cni\_addon](#input\_enable\_vpc\_cni\_addon) | Whether to enable the EKS AWS CNI addon or not | `bool` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_gitlab_cidr"></a> [gitlab\_cidr](#input\_gitlab\_cidr) | n/a | `list(string)` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | n/a | `string` | n/a | yes |
| <a name="input_is_calico_enabled"></a> [is\_calico\_enabled](#input\_is\_calico\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_is_gp3_default"></a> [is\_gp3\_default](#input\_is\_gp3\_default) | Set to true to set gp3 storageClass as default | `string` | `"true"` | no |
| <a name="input_kube_proxy_addon_version"></a> [kube\_proxy\_addon\_version](#input\_kube\_proxy\_addon\_version) | The version of the EKS Kube Proxy addon | `string` | n/a | yes |
| <a name="input_log_types"></a> [log\_types](#input\_log\_types) | n/a | `list(string)` | n/a | yes |
| <a name="input_map_subnets"></a> [map\_subnets](#input\_map\_subnets) | Map of availability zones and their subnets | `map(any)` | n/a | yes |
| <a name="input_matterwick_cluster_access_enabled"></a> [matterwick\_cluster\_access\_enabled](#input\_matterwick\_cluster\_access\_enabled) | n/a | `bool` | n/a | yes |
| <a name="input_matterwick_iam_user"></a> [matterwick\_iam\_user](#input\_matterwick\_iam\_user) | n/a | `string` | n/a | yes |
| <a name="input_matterwick_username"></a> [matterwick\_username](#input\_matterwick\_username) | n/a | `string` | n/a | yes |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | n/a | `string` | n/a | yes |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | n/a | `string` | n/a | yes |
| <a name="input_node_group_name"></a> [node\_group\_name](#input\_node\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_node_volume_size"></a> [node\_volume\_size](#input\_node\_volume\_size) | n/a | `number` | n/a | yes |
| <a name="input_node_volume_type"></a> [node\_volume\_type](#input\_node\_volume\_type) | n/a | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | n/a | `list(any)` | n/a | yes |
| <a name="input_provider_role_arn"></a> [provider\_role\_arn](#input\_provider\_role\_arn) | n/a | `string` | `""` | no |
| <a name="input_public_subnet_ids"></a> [public\_subnet\_ids](#input\_public\_subnet\_ids) | n/a | `list(any)` | n/a | yes |
| <a name="input_spot_desired_size"></a> [spot\_desired\_size](#input\_spot\_desired\_size) | The desired number of nodes in the spot node group | `number` | `0` | no |
| <a name="input_spot_instance_type"></a> [spot\_instance\_type](#input\_spot\_instance\_type) | The instance type used for the nodes in the spot node group | `string` | n/a | yes |
| <a name="input_spot_max_size"></a> [spot\_max\_size](#input\_spot\_max\_size) | The maximum number of nodes in the spot node group | `number` | `1` | no |
| <a name="input_spot_min_size"></a> [spot\_min\_size](#input\_spot\_min\_size) | The minimum number of nodes in the spot node group | `number` | `0` | no |
| <a name="input_storage_class_volume_type"></a> [storage\_class\_volume\_type](#input\_storage\_class\_volume\_type) | Type of volume | `string` | `"gp3"` | no |
| <a name="input_teleport_cidr"></a> [teleport\_cidr](#input\_teleport\_cidr) | n/a | `list(string)` | n/a | yes |
| <a name="input_use_al2023"></a> [use\_al2023](#input\_use\_al2023) | Enable AL2023-specific configurations. Defaults to false for AL2. | `bool` | `false` | no |
| <a name="input_vpc_cni_addon_version"></a> [vpc\_cni\_addon\_version](#input\_vpc\_cni\_addon\_version) | The version of the EKS VPC CNI addon | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster-sg"></a> [cluster-sg](#output\_cluster-sg) | n/a |
| <a name="output_config_map_aws_auth"></a> [config\_map\_aws\_auth](#output\_config\_map\_aws\_auth) | n/a |
| <a name="output_eks_cluster_certificate_authority"></a> [eks\_cluster\_certificate\_authority](#output\_eks\_cluster\_certificate\_authority) | n/a |
| <a name="output_eks_cluster_endpoint"></a> [eks\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | n/a |
| <a name="output_eks_cluster_name"></a> [eks\_cluster\_name](#output\_eks\_cluster\_name) | n/a |
| <a name="output_eks_cluster_service_cidr"></a> [eks\_cluster\_service\_cidr](#output\_eks\_cluster\_service\_cidr) | n/a |
| <a name="output_lambda_role_arn"></a> [lambda\_role\_arn](#output\_lambda\_role\_arn) | n/a |
| <a name="output_lambda_role_id"></a> [lambda\_role\_id](#output\_lambda\_role\_id) | n/a |
| <a name="output_lambda_role_name"></a> [lambda\_role\_name](#output\_lambda\_role\_name) | n/a |
| <a name="output_worker-role"></a> [worker-role](#output\_worker-role) | n/a |
| <a name="output_worker_security_group"></a> [worker\_security\_group](#output\_worker\_security\_group) | n/a |
