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
| [kubernetes_cron_job.cloud_blackbox_target_discovery_cron](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cron_job) | resource |
| [kubernetes_role.cloud_blackbox_target_discovery_role](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role) | resource |
| [kubernetes_role_binding.cloud_blackbox_target_discovery_role_binding](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding) | resource |
| [kubernetes_service_account.cloud_blackbox_target_discovery_role_sa](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_targets"></a> [additional\_targets](#input\_additional\_targets) | The addiational targets in a comma separated manner for DNS | `string` | n/a | yes |
| <a name="input_bind_servers"></a> [bind\_servers](#input\_bind\_servers) | The comma separated of IPs eg. 10.0.1.0:9153,10.0.2.0:9153 | `string` | n/a | yes |
| <a name="input_blackbox_target_discovery_cronjob_schedule"></a> [blackbox\_target\_discovery\_cronjob\_schedule](#input\_blackbox\_target\_discovery\_cronjob\_schedule) | The schedule for the Kubernetes cron job | `string` | n/a | yes |
| <a name="input_cloud_blackbox_target_discovery_image"></a> [cloud\_blackbox\_target\_discovery\_image](#input\_cloud\_blackbox\_target\_discovery\_image) | The image of the container for blackbox | `string` | n/a | yes |
| <a name="input_excluded_targets"></a> [excluded\_targets](#input\_excluded\_targets) | The excluded targets in a comma separated manner for DNS | `string` | n/a | yes |
| <a name="input_mattermost_alerts_hook"></a> [mattermost\_alerts\_hook](#input\_mattermost\_alerts\_hook) | The URL alert hook where we can send notifications | `string` | n/a | yes |
| <a name="input_monitoring_namespace"></a> [monitoring\_namespace](#input\_monitoring\_namespace) | The prometheus monitoring namespace which will be used in blackbox configuration | `string` | n/a | yes |
| <a name="input_private_hosted_zone_id"></a> [private\_hosted\_zone\_id](#input\_private\_hosted\_zone\_id) | The ID of the private Hosted zone | `string` | n/a | yes |
| <a name="input_prometheus_secret_name"></a> [prometheus\_secret\_name](#input\_prometheus\_secret\_name) | The secret name that will be created to store the scrape config with the Blackbox targets. The same name should be used in the Prometheus Operator chart values | `string` | n/a | yes |
| <a name="input_public_hosted_zone_id"></a> [public\_hosted\_zone\_id](#input\_public\_hosted\_zone\_id) | The ID of the public Hosted zone | `string` | n/a | yes |

## Outputs

No outputs.
