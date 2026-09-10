## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.41.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.41.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_api_gateway_deployment.public_webhook](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment) | resource |
| [aws_api_gateway_integration.route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration) | resource |
| [aws_api_gateway_method.route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method) | resource |
| [aws_api_gateway_method_settings.route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_settings) | resource |
| [aws_api_gateway_resource.route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource) | resource |
| [aws_api_gateway_rest_api.public_webhook](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api) | resource |
| [aws_api_gateway_stage.public_webhook](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_stage) | resource |
| [aws_cloudwatch_log_group.access_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_lambda_permission.route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_deployment_name"></a> [deployment\_name](#input\_deployment\_name) | Name prefix for the gateway and its resources, e.g. "core" | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name, used as the API Gateway stage name | `string` | n/a | yes |
| <a name="input_routes"></a> [routes](#input\_routes) | Public webhook routes to expose. The map key is the URL path segment, so a key<br/>of "github-cursor-webhook" is served at <invoke\_url>/github-cursor-webhook.<br/><br/>Each value points at the Lambda behind that route. The Lambda itself is created<br/>elsewhere; this module only adds the route and the invoke permission for it. | <pre>map(object({<br/>    lambda_function_name = string<br/>    lambda_invoke_arn    = string<br/>  }))</pre> | n/a | yes |
| <a name="input_enable_access_logging"></a> [enable\_access\_logging](#input\_enable\_access\_logging) | Write API Gateway access logs to CloudWatch for this stage.<br/><br/>Defaults to false because REST API access logging requires an account-level<br/>CloudWatch Logs role (API Gateway account setting `cloudwatchRoleArn`), which is<br/>an account-wide singleton and is deliberately not managed by this module. Enabling<br/>this before that role exists produces a stage that fails to deliver logs.<br/><br/>CloudWatch *metrics* (request count, 4xx, 5xx, latency) are always enabled and<br/>need no such role. | `bool` | `false` | no |
| <a name="input_log_retention_in_days"></a> [log\_retention\_in\_days](#input\_log\_retention\_in\_days) | Retention for the access log group, in days. 0 means never expire. Only used when enable\_access\_logging is true. | `number` | `30` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to the gateway, stage and log group | `map(string)` | `{}` | no |
| <a name="input_throttling_burst_limit"></a> [throttling\_burst\_limit](#input\_throttling\_burst\_limit) | Burst capacity allowed per method, enforced at the edge before the Lambda is invoked. -1 disables throttling; see the warning on throttling\_rate\_limit. | `number` | `100` | no |
| <a name="input_throttling_rate_limit"></a> [throttling\_rate\_limit](#input\_throttling\_rate\_limit) | Steady-state requests per second allowed per method, enforced at the edge before<br/>the Lambda is invoked.<br/><br/>-1 disables throttling. Be deliberate about that on a public endpoint: edge<br/>throttling is the main reason to put this gateway in front of a Lambda that<br/>already authenticates its own requests, so -1 gives up the protection this<br/>module exists to provide. | `number` | `50` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_execution_arn"></a> [execution\_arn](#output\_execution\_arn) | Execution ARN of the REST API, for granting additional invoke permissions outside this module |
| <a name="output_invoke_url"></a> [invoke\_url](#output\_invoke\_url) | Base invoke URL for the stage, e.g. https://abc123.execute-api.us-east-1.amazonaws.com/core |
| <a name="output_rest_api_id"></a> [rest\_api\_id](#output\_rest\_api\_id) | ID of the REST API, useful for CloudWatch metric dimensions and manual redeploys |
| <a name="output_route_urls"></a> [route\_urls](#output\_route\_urls) | Full public URL per route, keyed by route name. Give these to the webhook provider as the payload URL. |
| <a name="output_stage_name"></a> [stage\_name](#output\_stage\_name) | Deployed stage name |
