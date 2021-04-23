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
| [aws_route53_record.chartmuseum](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [helm_release.chartmuseum](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.chartmuseum](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [helm_repository.stable](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/data-sources/repository) | data source |
| [kubernetes_service.internal_nginx](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chartmuseum_bucket"></a> [chartmuseum\_bucket](#input\_chartmuseum\_bucket) | The S3 bucket where we push the charts | `string` | n/a | yes |
| <a name="input_chartmuseum_chart_values_directory"></a> [chartmuseum\_chart\_values\_directory](#input\_chartmuseum\_chart\_values\_directory) | The helm values directory to be used for deployment | `string` | n/a | yes |
| <a name="input_chartmuseum_hostname"></a> [chartmuseum\_hostname](#input\_chartmuseum\_hostname) | The dns hostname for chartmuseum | `string` | n/a | yes |
| <a name="input_chartmuseum_user_access_key"></a> [chartmuseum\_user\_access\_key](#input\_chartmuseum\_user\_access\_key) | The AWS user access key | `string` | n/a | yes |
| <a name="input_chartmuseum_user_key_id"></a> [chartmuseum\_user\_key\_id](#input\_chartmuseum\_user\_key\_id) | The AWS user access key ID | `string` | n/a | yes |
| <a name="input_deployment_name"></a> [deployment\_name](#input\_deployment\_name) | The name of the deployment | `string` | n/a | yes |
| <a name="input_kubeconfig_dir"></a> [kubeconfig\_dir](#input\_kubeconfig\_dir) | The directory where the generated kubeconfig will be appended by terraform provider | `string` | n/a | yes |
| <a name="input_private_hosted_zoneid"></a> [private\_hosted\_zoneid](#input\_private\_hosted\_zoneid) | The private Hosted zone ID | `string` | n/a | yes |

## Outputs

No outputs.
