## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.41.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.5.1 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.2.2 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.6.2 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.12.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.41.0 |
| <a name="provider_local"></a> [local](#provider\_local) | >= 2.5.1 |
| <a name="provider_null"></a> [null](#provider\_null) | >= 3.2.2 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.6.2 |
| <a name="provider_time"></a> [time](#provider\_time) | >= 0.12.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | 20.37.1 |
| <a name="module_irsa"></a> [irsa](#module\_irsa) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | 5.44.0 |
| <a name="module_managed_node_group"></a> [managed\_node\_group](#module\_managed\_node\_group) | terraform-aws-modules/eks/aws//modules/eks-managed-node-group | 20.37.1 |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_tag.subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_tag) | resource |
| [aws_ec2_tag.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_tag) | resource |
| [aws_eks_addon.coredns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.ebs_csi_driver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.efs_csi_driver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.kube_proxy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.snapshot-controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_iam_policy.bifrost](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.cluster-autoscaler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.external-dns-internal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.external-secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.velero](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_launch_template.node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_secretsmanager_secret.kubeconfig_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.kubeconfig_secret_version](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [local_file.kubeconfig](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.bifrost_annotate_sa](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.bifrost_config](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.calico_felix_configuration](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.calico_operator_configuration](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.delete_aws_node](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.deploy-utilites](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.install_calico_operator](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.node_group_annotate](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.pgbouncer_initial_setup](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.tag_vpc](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_id.cluster](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [time_sleep.wait_for_cluster](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [time_sleep.wait_for_utilities](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_security_groups.calls](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_groups) | data source |
| [aws_security_groups.control-plane](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_groups) | data source |
| [aws_security_groups.nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_groups) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.private-a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_list_cidr_range"></a> [allow\_list\_cidr\_range](#input\_allow\_list\_cidr\_range) | The list of CIDRs to allow communication with the private ingress. | `string` | n/a | yes |
| <a name="input_argocd_role_arn"></a> [argocd\_role\_arn](#input\_argocd\_role\_arn) | The argocd role arn | `string` | n/a | yes |
| <a name="input_argocd_server"></a> [argocd\_server](#input\_argocd\_server) | The argocd server | `string` | n/a | yes |
| <a name="input_atlantis_user_arn"></a> [atlantis\_user\_arn](#input\_atlantis\_user\_arn) | The atlantis user arn | `string` | n/a | yes |
| <a name="input_attach_cluster_encryption_policy"></a> [attach\_cluster\_encryption\_policy](#input\_attach\_cluster\_encryption\_policy) | Indicates whether or not to attach an additional policy for the cluster IAM role to utilize the encryption key provided | `bool` | `false` | no |
| <a name="input_calico_operator_version"></a> [calico\_operator\_version](#input\_calico\_operator\_version) | The version of the Calico operator | `string` | n/a | yes |
| <a name="input_cluster_enabled_log_types"></a> [cluster\_enabled\_log\_types](#input\_cluster\_enabled\_log\_types) | The list of log types to enable | `list(string)` | n/a | yes |
| <a name="input_cluster_encryption_config"></a> [cluster\_encryption\_config](#input\_cluster\_encryption\_config) | Configuration block with encryption configuration for the cluster. To disable secret encryption, set this value to `{}` | `any` | `{}` | no |
| <a name="input_cluster_endpoint_private_access"></a> [cluster\_endpoint\_private\_access](#input\_cluster\_endpoint\_private\_access) | Indicates whether or not the Amazon EKS private API server endpoint is enabled | `bool` | n/a | yes |
| <a name="input_cluster_endpoint_public_access"></a> [cluster\_endpoint\_public\_access](#input\_cluster\_endpoint\_public\_access) | Indicates whether or not the Amazon EKS public API server endpoint is enabled | `bool` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The cluster name | `string` | n/a | yes |
| <a name="input_cluster_security_group_additional_rules"></a> [cluster\_security\_group\_additional\_rules](#input\_cluster\_security\_group\_additional\_rules) | The list of additional security group rules for the EKS cluster | <pre>map(object({<br/>    from_port   = number<br/>    to_port     = number<br/>    protocol    = string<br/>    cidr_blocks = list(string)<br/>    type        = string<br/>  }))</pre> | n/a | yes |
| <a name="input_cluster_tags"></a> [cluster\_tags](#input\_cluster\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | The Kubernetes version for the EKS cluster | `string` | n/a | yes |
| <a name="input_coredns_version"></a> [coredns\_version](#input\_coredns\_version) | The version of the CoreDNS addon | `string` | n/a | yes |
| <a name="input_create_cluster_security_group"></a> [create\_cluster\_security\_group](#input\_create\_cluster\_security\_group) | Indicates whether or not to create a security group for the EKS cluster | `bool` | `true` | no |
| <a name="input_create_iam_role"></a> [create\_iam\_role](#input\_create\_iam\_role) | Determines whether an IAM role is created or to use an existing IAM role | `bool` | `true` | no |
| <a name="input_create_kms_key"></a> [create\_kms\_key](#input\_create\_kms\_key) | Controls if a KMS key for cluster encryption should be created | `bool` | `false` | no |
| <a name="input_create_launch_template"></a> [create\_launch\_template](#input\_create\_launch\_template) | Indicates whether or not to create a launch template for the EKS managed node group | `bool` | `false` | no |
| <a name="input_create_node_security_group"></a> [create\_node\_security\_group](#input\_create\_node\_security\_group) | Indicates whether or not to create a security group for the EKS nodes | `bool` | `false` | no |
| <a name="input_device_name"></a> [device\_name](#input\_device\_name) | The device name | `string` | `"/dev/xvda"` | no |
| <a name="input_ebs_csi_driver_version"></a> [ebs\_csi\_driver\_version](#input\_ebs\_csi\_driver\_version) | The version of the EBS CSI driver addon | `string` | n/a | yes |
| <a name="input_ebs_optimized"></a> [ebs\_optimized](#input\_ebs\_optimized) | If true, the launched EC2 instance will be EBS-optimized | `bool` | `null` | no |
| <a name="input_efs_csi_driver_version"></a> [efs\_csi\_driver\_version](#input\_efs\_csi\_driver\_version) | The version of the EFS CSI driver addon | `string` | n/a | yes |
| <a name="input_eks_cluster_admin_policy_arn"></a> [eks\_cluster\_admin\_policy\_arn](#input\_eks\_cluster\_admin\_policy\_arn) | The ARN of the AmazonEKSClusterAdminPolicy | `string` | `"arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"` | no |
| <a name="input_enable_auto_mode_custom_tags"></a> [enable\_auto\_mode\_custom\_tags](#input\_enable\_auto\_mode\_custom\_tags) | Indicates whether or not to enable auto mode custom tags | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment | `string` | n/a | yes |
| <a name="input_github_app_id"></a> [github\_app\_id](#input\_github\_app\_id) | The app id for the Github App | `string` | n/a | yes |
| <a name="input_github_app_installation_id"></a> [github\_app\_installation\_id](#input\_github\_app\_installation\_id) | The installation id for the Github App | `string` | n/a | yes |
| <a name="input_github_app_pem_key_path"></a> [github\_app\_pem\_key\_path](#input\_github\_app\_pem\_key\_path) | The path of the Github App PEM | `string` | n/a | yes |
| <a name="input_gitops_repo_email"></a> [gitops\_repo\_email](#input\_gitops\_repo\_email) | The git repo email for executing git commands | `string` | n/a | yes |
| <a name="input_gitops_repo_path"></a> [gitops\_repo\_path](#input\_gitops\_repo\_path) | The git repo path | `string` | n/a | yes |
| <a name="input_gitops_repo_url"></a> [gitops\_repo\_url](#input\_gitops\_repo\_url) | The git repo url | `string` | n/a | yes |
| <a name="input_gitops_repo_username"></a> [gitops\_repo\_username](#input\_gitops\_repo\_username) | The git repo username for executing git commands | `string` | n/a | yes |
| <a name="input_iam_role_use_name_prefix"></a> [iam\_role\_use\_name\_prefix](#input\_iam\_role\_use\_name\_prefix) | Determines whether the IAM role name (`iam_role_name`) is used as a prefix | `bool` | `false` | no |
| <a name="input_kube_proxy_version"></a> [kube\_proxy\_version](#input\_kube\_proxy\_version) | The version of the kube-proxy addon | `string` | n/a | yes |
| <a name="input_lb_certificate_arn"></a> [lb\_certificate\_arn](#input\_lb\_certificate\_arn) | The certificate arn | `string` | n/a | yes |
| <a name="input_lb_private_certificate_arn"></a> [lb\_private\_certificate\_arn](#input\_lb\_private\_certificate\_arn) | The private certificate arn | `string` | n/a | yes |
| <a name="input_node_groups"></a> [node\_groups](#input\_node\_groups) | The list of node groups | <pre>map(object({<br/>    min_size          = number<br/>    max_size          = number<br/>    desired_size      = number<br/>    instance_types    = list(string)<br/>    ami_id            = string<br/>    max_pods          = optional(number, 110)<br/>    volume_throughput = optional(number, 125)<br/>    taints = optional(map(object({<br/>      key    = string<br/>      value  = string<br/>      effect = string<br/>    })), {})<br/>    labels = optional(map(string), {})<br/>    network_interfaces = optional(list(object({<br/>      security_groups             = list(string)<br/>      associate_public_ip_address = bool<br/>    })), [])<br/>    public_subnet = optional(bool, false)<br/>    annotations   = optional(map(string), {})<br/>  }))</pre> | n/a | yes |
| <a name="input_pause_container_image"></a> [pause\_container\_image](#input\_pause\_container\_image) | The pause container image to use for the node group | `string` | `"602401143452.dkr.ecr.us-east-1.amazonaws.com/eks/pause:3.5"` | no |
| <a name="input_private_domain"></a> [private\_domain](#input\_private\_domain) | The private domain | `string` | n/a | yes |
| <a name="input_provisioner_role_arn"></a> [provisioner\_role\_arn](#input\_provisioner\_role\_arn) | The provisioner role arn | `string` | n/a | yes |
| <a name="input_push_utilities_to_main"></a> [push\_utilities\_to\_main](#input\_push\_utilities\_to\_main) | Indicates whether or not to automatically push utilities to the Gitops repository | `bool` | `true` | no |
| <a name="input_region"></a> [region](#input\_region) | The region for the EKS cluster | `string` | `"us-east-1"` | no |
| <a name="input_snapshot_controller_version"></a> [snapshot\_controller\_version](#input\_snapshot\_controller\_version) | n/a | `string` | n/a | yes |
| <a name="input_staff_role_arn"></a> [staff\_role\_arn](#input\_staff\_role\_arn) | The staff role arn | `string` | n/a | yes |
| <a name="input_update_config"></a> [update\_config](#input\_update\_config) | Configuration block of settings for max unavailable resources during node group updates | `map(string)` | <pre>{<br/>  "max_unavailable": 1<br/>}</pre> | no |
| <a name="input_use_al2023"></a> [use\_al2023](#input\_use\_al2023) | Enable AL2023-specific configurations. Defaults to false for AL2. | `bool` | `false` | no |
| <a name="input_use_name_prefix"></a> [use\_name\_prefix](#input\_use\_name\_prefix) | Determines whether to use `name` as is or create a unique name beginning with the `name` as the prefix | `bool` | `false` | no |
| <a name="input_utilities"></a> [utilities](#input\_utilities) | The list of utilities | <pre>list(object({<br/>    name                      = string<br/>    enable_irsa               = bool<br/>    internal_dns              = any<br/>    namespace_service_account = string<br/>    cluster_label_type        = string<br/>  }))</pre> | n/a | yes |
| <a name="input_volume_delete_on_termination"></a> [volume\_delete\_on\_termination](#input\_volume\_delete\_on\_termination) | Indicates whether the EBS volume is deleted on termination | `bool` | `true` | no |
| <a name="input_volume_encrypted"></a> [volume\_encrypted](#input\_volume\_encrypted) | Indicates whether the EBS volume is encrypted | `bool` | `true` | no |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | The size of the EBS volume | `number` | `128` | no |
| <a name="input_volume_type"></a> [volume\_type](#input\_volume\_type) | Worker node volume type | `string` | `"gp3"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID for the EKS cluster | `string` | n/a | yes |
| <a name="input_wait_for_cluster_timeout"></a> [wait\_for\_cluster\_timeout](#input\_wait\_for\_cluster\_timeout) | The timeout to wait for the EKS cluster to be ready | `string` | `"3m"` | no |
| <a name="input_wait_for_utilities_timeout"></a> [wait\_for\_utilities\_timeout](#input\_wait\_for\_utilities\_timeout) | The timeout to wait for the EKS cluster to be ready | `string` | `"5m"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | n/a |
| <a name="output_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#output\_cluster\_certificate\_authority\_data) | n/a |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | n/a |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | n/a |
| <a name="output_cluster_primary_security_group_id"></a> [cluster\_primary\_security\_group\_id](#output\_cluster\_primary\_security\_group\_id) | n/a |
| <a name="output_cluster_service_cidr"></a> [cluster\_service\_cidr](#output\_cluster\_service\_cidr) | n/a |
| <a name="output_cluster_version"></a> [cluster\_version](#output\_cluster\_version) | n/a |
| <a name="output_node_security_group_id"></a> [node\_security\_group\_id](#output\_node\_security\_group\_id) | n/a |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | n/a |
