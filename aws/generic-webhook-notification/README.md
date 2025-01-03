## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.41.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.41.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_api_gateway_integration.elrond-notification-integration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration) | resource |
| [aws_api_gateway_integration.gitlab-webhook-integration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration) | resource |
| [aws_api_gateway_integration.notification-integration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration) | resource |
| [aws_api_gateway_method.elrond-notification-post](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method) | resource |
| [aws_api_gateway_method.gitlab-webhook-post](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method) | resource |
| [aws_api_gateway_method.notification-post](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method) | resource |
| [aws_api_gateway_resource.elrond-notification-resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource) | resource |
| [aws_api_gateway_resource.gitlab-webhook-resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource) | resource |
| [aws_api_gateway_resource.provisioner-notification-resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource) | resource |
| [aws_api_gateway_rest_api.core-generic-webhook-notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api) | resource |
| [aws_iam_role.generic-webhook](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.generic-webhook-lambda-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lambda_function.elrond-notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.gitlab-webhook](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.provisioner-notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.elrond-notification-permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.gitlab-webhook-permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.provisioner-notification-permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_security_group.generic-lambda_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_deployment_name"></a> [deployment\_name](#input\_deployment\_name) | The name of the deployment for Lambda | `string` | n/a | yes |
| <a name="input_enable_arm64"></a> [enable\_arm64](#input\_enable\_arm64) | Enable ARM64 architecture for Lambda | `bool` | `false` | no |
| <a name="input_lambda_elrond_notification_s3_key"></a> [lambda\_elrond\_notification\_s3\_key](#input\_lambda\_elrond\_notification\_s3\_key) | The S3 key where the elrond notification lambda function is stored | `string` | n/a | yes |
| <a name="input_lambda_gitlab_webhook_s3_key"></a> [lambda\_gitlab\_webhook\_s3\_key](#input\_lambda\_gitlab\_webhook\_s3\_key) | The S3 key where the gitlab webhook lambda function is stored | `string` | n/a | yes |
| <a name="input_lambda_provisioner_notification_s3_key"></a> [lambda\_provisioner\_notification\_s3\_key](#input\_lambda\_provisioner\_notification\_s3\_key) | The S3 key where the provisioner notification lambda function is stored | `string` | n/a | yes |
| <a name="input_lambda_s3_bucket"></a> [lambda\_s3\_bucket](#input\_lambda\_s3\_bucket) | The S3 bucket where the lambda function is stored | `string` | n/a | yes |
| <a name="input_mattermost_elrond_webhook_prod"></a> [mattermost\_elrond\_webhook\_prod](#input\_mattermost\_elrond\_webhook\_prod) | n/a | `string` | n/a | yes |
| <a name="input_mattermost_notification_hook"></a> [mattermost\_notification\_hook](#input\_mattermost\_notification\_hook) | n/a | `string` | n/a | yes |
| <a name="input_mattermost_webhook_alert_prod"></a> [mattermost\_webhook\_alert\_prod](#input\_mattermost\_webhook\_alert\_prod) | n/a | `string` | n/a | yes |
| <a name="input_mattermost_webhook_prod"></a> [mattermost\_webhook\_prod](#input\_mattermost\_webhook\_prod) | n/a | `string` | n/a | yes |
| <a name="input_pagerduty_integration_key"></a> [pagerduty\_integration\_key](#input\_pagerduty\_integration\_key) | The integration key for the PagerDuty integration | `string` | n/a | yes |
| <a name="input_parent_id"></a> [parent\_id](#input\_parent\_id) | n/a | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | The list of the private subnet IDs are used by generic-webhook lambdas | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of VPC is used by the generic-webhook lambdas | `string` | n/a | yes |

## Outputs

No outputs.
