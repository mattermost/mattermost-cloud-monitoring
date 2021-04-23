## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_cron_job.cloud_thanos_store_discovery_cron](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cron_job) | resource |
| [kubernetes_role.cloud_thanos_store_discovery_role](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role) | resource |
| [kubernetes_role_binding.cloud_thanos_store_discovery_role_binding](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding) | resource |
| [kubernetes_service_account.cloud_thanos_store_discovery_role_sa](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_thanos_store_discovery_image"></a> [cloud\_thanos\_store\_discovery\_image](#input\_cloud\_thanos\_store\_discovery\_image) | n/a | `any` | n/a | yes |
| <a name="input_mattermost_alerts_hook"></a> [mattermost\_alerts\_hook](#input\_mattermost\_alerts\_hook) | n/a | `any` | n/a | yes |
| <a name="input_monitoring_namespace"></a> [monitoring\_namespace](#input\_monitoring\_namespace) | n/a | `any` | n/a | yes |
| <a name="input_private_hosted_zone_id"></a> [private\_hosted\_zone\_id](#input\_private\_hosted\_zone\_id) | n/a | `any` | n/a | yes |
| <a name="input_thanos_configmap_name"></a> [thanos\_configmap\_name](#input\_thanos\_configmap\_name) | n/a | `any` | n/a | yes |
| <a name="input_thanos_deployment_name"></a> [thanos\_deployment\_name](#input\_thanos\_deployment\_name) | n/a | `any` | n/a | yes |
| <a name="input_thanos_store_discovery_cronjob_schedule"></a> [thanos\_store\_discovery\_cronjob\_schedule](#input\_thanos\_store\_discovery\_cronjob\_schedule) | n/a | `any` | n/a | yes |

## Outputs

No outputs.
