## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.atlantis-asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_iam_instance_profile.atlantis-instance-profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.atlantis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_launch_configuration.atlantis-lc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration) | resource |
| [aws_route53_record.atlantis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.atlantis-sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [helm_release.atlantis](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.internal_nginx](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_cluster_role.atlantis](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role_binding.atlantis](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_namespace.atlantis](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.internal_nginx](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [aws_acm_certificate.internal_core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_elb_hosted_zone_id.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/elb_hosted_zone_id) | data source |
| [kubernetes_service.internal_nginx](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | The AMI ID which will be used for the launch configuration where will deploy the Atlantis UI | `string` | n/a | yes |
| <a name="input_atlantis_chart_values_directory"></a> [atlantis\_chart\_values\_directory](#input\_atlantis\_chart\_values\_directory) | The atlantis helm values directory | `string` | n/a | yes |
| <a name="input_atlantis_chart_version"></a> [atlantis\_chart\_version](#input\_atlantis\_chart\_version) | The atlantis helm chart version which will be deployed in kubernetes | `string` | n/a | yes |
| <a name="input_atlantis_deployment_name"></a> [atlantis\_deployment\_name](#input\_atlantis\_deployment\_name) | The name of the deployment name which be used for ASG | `string` | n/a | yes |
| <a name="input_atlantis_hostname"></a> [atlantis\_hostname](#input\_atlantis\_hostname) | The atlantis hostname eg. atlantis.foo.com | `string` | n/a | yes |
| <a name="input_aws_secretname"></a> [aws\_secretname](#input\_aws\_secretname) | The atlantis secret name which will be used to provide the necessary credentials profiles for terraform | `string` | n/a | yes |
| <a name="input_deployment_name"></a> [deployment\_name](#input\_deployment\_name) | The name of the deployment name which be used for launch configuration | `string` | n/a | yes |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | The desired capacity of ASG | `number` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment which will deploy to and will be added as a tag | `string` | n/a | yes |
| <a name="input_gitlab_hostname"></a> [gitlab\_hostname](#input\_gitlab\_hostname) | The gitlab root hostname eg. gitlab.com | `string` | n/a | yes |
| <a name="input_gitlab_token"></a> [gitlab\_token](#input\_gitlab\_token) | The gitlab token which will be used by Atlantis to get webhook events | `string` | n/a | yes |
| <a name="input_gitlab_user"></a> [gitlab\_user](#input\_gitlab\_user) | The gitlab user which will be used by Atlantis to get webhook events | `string` | n/a | yes |
| <a name="input_gitlab_webhook_secret"></a> [gitlab\_webhook\_secret](#input\_gitlab\_webhook\_secret) | The gitlab secret which will be used by Atlantis to get webhook events | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type will be used for launch configuration and ASG | `string` | n/a | yes |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | The SSH key name to use for accessing the ASG nodes | `string` | n/a | yes |
| <a name="input_kubeconfig_dir"></a> [kubeconfig\_dir](#input\_kubeconfig\_dir) | The directory where the generated kubeconfig will be appended by terraform provider | `string` | n/a | yes |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | The maximum number of nodes for ASG | `number` | n/a | yes |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | The minimum number of nodes for ASG | `number` | n/a | yes |
| <a name="input_nginx_internal_chart_values_directory"></a> [nginx\_internal\_chart\_values\_directory](#input\_nginx\_internal\_chart\_values\_directory) | The nginx helm values directory which will be used to deploy an nginx along with it | `string` | n/a | yes |
| <a name="input_org_whitelist"></a> [org\_whitelist](#input\_org\_whitelist) | The organization whitelist for git repositories which will be observed by atlantis | `string` | n/a | yes |
| <a name="input_private_hosted_zoneid"></a> [private\_hosted\_zoneid](#input\_private\_hosted\_zoneid) | The ID of the Route53 private hosted zone | `string` | n/a | yes |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | The attached security group ID list for launch configuration of Atlantis UI | `list(string)` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The subnet ID for the ASG and the VPC zones | `string` | n/a | yes |
| <a name="input_terraform_default_version"></a> [terraform\_default\_version](#input\_terraform\_default\_version) | The terraform default version which Atlantis will use for terraform binary | `string` | n/a | yes |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | The root block device volume size for launch configuration of Atlantis UI | `string` | n/a | yes |

## Outputs

No outputs.
