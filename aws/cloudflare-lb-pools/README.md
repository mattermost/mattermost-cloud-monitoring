<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | ~> 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [cloudflare_load_balancer_monitor.https_monitor](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/load_balancer_monitor) | resource |
| [cloudflare_load_balancer_pool.lb-pool](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/load_balancer_pool) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | The Description about cloudflare LB Pool Usage | `string` | n/a | yes |
| <a name="input_expected_codes"></a> [expected\_codes](#input\_expected\_codes) | The expected HTTP response code or code range of the health check. Eg 2xx. Only valid and required if type is http or https | `string` | n/a | yes |
| <a name="input_follow_redirects"></a> [follow\_redirects](#input\_follow\_redirects) | Follow redirects if returned by the origin. Only valid if type is http or https. | `bool` | n/a | yes |
| <a name="input_header"></a> [header](#input\_header) | Name of the header i.e Host | `string` | n/a | yes |
| <a name="input_header_value"></a> [header\_value](#input\_header\_value) | Value for the header | `string` | n/a | yes |
| <a name="input_interval"></a> [interval](#input\_interval) | The interval between each health check, Shorter intervals may improve failover time, but will increase load on the origins as we check from multiple locations. Default: 60. | `number` | n/a | yes |
| <a name="input_monitor_method"></a> [monitor\_method](#input\_monitor\_method) | The method to use for the health check. Valid values are any valid HTTP verb if type is http or https | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Cloudflare load balancer Pool's name | `string` | n/a | yes |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address for notofication from cloudflare | `string` | n/a | yes |
| <a name="input_policy"></a> [policy](#input\_policy) | Routing Policy for traffic. like Random etc | `string` | n/a | yes |
| <a name="input_pool_enable"></a> [pool\_enable](#input\_pool\_enable) | Used to enable/disable Pool | `bool` | n/a | yes |
| <a name="input_region_1"></a> [region\_1](#input\_region\_1) | Region for first origin | `string` | n/a | yes |
| <a name="input_region_1_address"></a> [region\_1\_address](#input\_region\_1\_address) | IP Address OR LB address to route the traffic | `string` | n/a | yes |
| <a name="input_region_1_enable"></a> [region\_1\_enable](#input\_region\_1\_enable) | Used to enable/disable traffic flow for Origin 1 | `string` | n/a | yes |
| <a name="input_region_1_weight"></a> [region\_1\_weight](#input\_region\_1\_weight) | A weight of 0 means traffic will not be sent to this origin, but health is still checked. Default: 1. | `string` | n/a | yes |
| <a name="input_region_2"></a> [region\_2](#input\_region\_2) | Region for second origin | `string` | n/a | yes |
| <a name="input_region_2_address"></a> [region\_2\_address](#input\_region\_2\_address) | IP Address OR LB address to route the traffic | `string` | n/a | yes |
| <a name="input_region_2_enable"></a> [region\_2\_enable](#input\_region\_2\_enable) | Used to enable/disable traffic flow for Origin 2 | `string` | n/a | yes |
| <a name="input_region_2_weight"></a> [region\_2\_weight](#input\_region\_2\_weight) | A weight of 0 means traffic will not be sent to this origin, but health is still checked. Default: 1. | `string` | n/a | yes |
| <a name="input_retries"></a> [retries](#input\_retries) | The number of retries to attempt in case of a timeout before marking the origin as unhealthy. Retries are attempted immediately. Default: 2. | `number` | n/a | yes |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | The timeout (in seconds) before marking the health check as failed. Default: 5. | `number` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->