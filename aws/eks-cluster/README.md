<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.61.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.61.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | >= 4.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_managed_node_group"></a> [managed\_node\_group](#module\_managed\_node\_group) | github.com/mattermost/mattermost-cloud-monitoring.git//aws/eks-managed-node-groups | v1.6.89 |

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
| [aws_security_group.cluster-sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.worker-sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.cluster-ingress-workstation-https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.master-teleport](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.worker-ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.worker-sg-ingress-cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.worker-sg-ingress-self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.worker-teleport](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [kubernetes_cluster_role.console_access](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role_binding.console_access](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_config_map.aws_auth_configmap](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster_auth.cluster_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [tls_certificate.cluster-openid-issuer](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_argocd_account_role"></a> [argocd\_account\_role](#input\_argocd\_account\_role) | n/a | `string` | n/a | yes |
| <a name="input_arm_desired_size"></a> [arm\_desired\_size](#input\_arm\_desired\_size) | The desired number of arm nodes in the node group | `string` | n/a | yes |
| <a name="input_arm_instance_type"></a> [arm\_instance\_type](#input\_arm\_instance\_type) | The instance type used for the arm nodes in the node group | `string` | n/a | yes |
| <a name="input_arm_max_size"></a> [arm\_max\_size](#input\_arm\_max\_size) | The maximum number of arm nodes in the node group | `string` | n/a | yes |
| <a name="input_arm_min_size"></a> [arm\_min\_size](#input\_arm\_min\_size) | The minimum number of arm nodes in the node group | `string` | n/a | yes |
| <a name="input_atlantis_user"></a> [atlantis\_user](#input\_atlantis\_user) | The atlantis user used for IaaC | `string` | n/a | yes |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of availability zones to place the instances | `list(string)` | n/a | yes |
| <a name="input_aws_reserved_sso_id"></a> [aws\_reserved\_sso\_id](#input\_aws\_reserved\_sso\_id) | n/a | `string` | n/a | yes |
| <a name="input_cidr_blocks"></a> [cidr\_blocks](#input\_cidr\_blocks) | n/a | `list(string)` | n/a | yes |
| <a name="input_cluster_short_name"></a> [cluster\_short\_name](#input\_cluster\_short\_name) | n/a | `string` | n/a | yes |
| <a name="input_coredns_addon_version"></a> [coredns\_addon\_version](#input\_coredns\_addon\_version) | The version of the EKS CoreDNS addon | `string` | n/a | yes |
| <a name="input_deployment_name"></a> [deployment\_name](#input\_deployment\_name) | n/a | `string` | n/a | yes |
| <a name="input_desired_size"></a> [desired\_size](#input\_desired\_size) | n/a | `string` | n/a | yes |
| <a name="input_ebs_csi_addon_version"></a> [ebs\_csi\_addon\_version](#input\_ebs\_csi\_addon\_version) | The version of the EKS EBS CSI addon | `string` | n/a | yes |
| <a name="input_eks_ami_id"></a> [eks\_ami\_id](#input\_eks\_ami\_id) | n/a | `string` | n/a | yes |
| <a name="input_eks_arm_image_id"></a> [eks\_arm\_image\_id](#input\_eks\_arm\_image\_id) | The AMI ID used for the arm nodes in the node group | `string` | n/a | yes |
| <a name="input_enable_coredns_addon"></a> [enable\_coredns\_addon](#input\_enable\_coredns\_addon) | Whether to enable the EKS CoreDNS addon or not | `bool` | n/a | yes |
| <a name="input_enable_ebs_csi_addon"></a> [enable\_ebs\_csi\_addon](#input\_enable\_ebs\_csi\_addon) | Whether to enable the EKS EBS CSI addon or not | `bool` | n/a | yes |
| <a name="input_enable_kube_proxy_addon"></a> [enable\_kube\_proxy\_addon](#input\_enable\_kube\_proxy\_addon) | Whether to enable the EKS Kube Proxy addon or not | `bool` | n/a | yes |
| <a name="input_enable_spot_nodes"></a> [enable\_spot\_nodes](#input\_enable\_spot\_nodes) | If true, spot nodes will be created | `bool` | `false` | no |
| <a name="input_enable_vpc_cni_addon"></a> [enable\_vpc\_cni\_addon](#input\_enable\_vpc\_cni\_addon) | Whether to enable the EKS AWS CNI addon or not | `bool` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | n/a | `string` | n/a | yes |
| <a name="input_kube_proxy_addon_version"></a> [kube\_proxy\_addon\_version](#input\_kube\_proxy\_addon\_version) | The version of the EKS Kube Proxy addon | `string` | n/a | yes |
| <a name="input_log_types"></a> [log\_types](#input\_log\_types) | n/a | `list(string)` | n/a | yes |
| <a name="input_map_subnets"></a> [map\_subnets](#input\_map\_subnets) | Map of availability zones and their subnets | `map(any)` | n/a | yes |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | n/a | `string` | n/a | yes |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | n/a | `string` | n/a | yes |
| <a name="input_node_group_name"></a> [node\_group\_name](#input\_node\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_node_volume_size"></a> [node\_volume\_size](#input\_node\_volume\_size) | n/a | `number` | n/a | yes |
| <a name="input_node_volume_type"></a> [node\_volume\_type](#input\_node\_volume\_type) | n/a | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | n/a | `list(string)` | n/a | yes |
| <a name="input_public_subnet_ids"></a> [public\_subnet\_ids](#input\_public\_subnet\_ids) | n/a | `list(string)` | n/a | yes |
| <a name="input_spot_desired_size"></a> [spot\_desired\_size](#input\_spot\_desired\_size) | The desired number of nodes in the spot node group | `number` | `0` | no |
| <a name="input_spot_instance_type"></a> [spot\_instance\_type](#input\_spot\_instance\_type) | The instance type used for the nodes in the spot node group | `string` | n/a | yes |
| <a name="input_spot_max_size"></a> [spot\_max\_size](#input\_spot\_max\_size) | The maximum number of nodes in the spot node group | `number` | `1` | no |
| <a name="input_spot_min_size"></a> [spot\_min\_size](#input\_spot\_min\_size) | The minimum number of nodes in the spot node group | `number` | `0` | no |
| <a name="input_teleport_cidr"></a> [teleport\_cidr](#input\_teleport\_cidr) | n/a | `list(string)` | n/a | yes |
| <a name="input_vpc_cni_addon_version"></a> [vpc\_cni\_addon\_version](#input\_vpc\_cni\_addon\_version) | The version of the EKS VPC CNI addon | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_config_map_aws_auth"></a> [config\_map\_aws\_auth](#output\_config\_map\_aws\_auth) | n/a |
| <a name="output_worker_role"></a> [worker\_role](#output\_worker\_role) | n/a |
| <a name="output_worker_security_group"></a> [worker\_security\_group](#output\_worker\_security\_group) | n/a |
<!-- END_TF_DOCS -->