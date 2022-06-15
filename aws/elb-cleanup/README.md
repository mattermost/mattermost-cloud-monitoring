### Overview
 
This terraform module can be used to create lambda with configurable AWS cloudwatch event rule (default is 7 days).
It automatically cleans up the unused elbs & classic load balancers.
 
### Usage Example
 
```hcl
module "elb-cleanup" {
 source             = "github.com/mattermost/mattermost-cloud-monitoring/terraform/aws/modules/elb-cleanup"
 private_subnet_ids = var.private_subnet_ids
 vpc_id             = var.vpc_id
 deployment_name    = var.deployment_name
 bucket             = var.bucket
 elb_cleanup_lambda_schedule  = "rate(7 days)"
 dryrun             = "true"
}
```
 
Note: Dry Run is a configurable environment variable which facilitates finding & listing unused ELBs & classic load balancers without deleting them.


<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.elb_cleanup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.elb_cleanup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_iam_role.elb_cleanup_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.elb_cleanup_lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.AWSLambdaBasicExecutionRoleELBCleanup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AWSLambdaVPCAccessExecutionRoleELBCleanup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.elb_cleanup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.allow_cloudwatch_to_call_elb_cleanup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_security_group.elb_cleanup_lambda_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket"></a> [bucket](#input\_bucket) | S3 bucket where the elb-cleanup lambda is stored | `string` | n/a | yes |
| <a name="input_deployment_name"></a> [deployment\_name](#input\_deployment\_name) | The name of the deployment for Lambda | `string` | n/a | yes |
| <a name="input_dryrun"></a> [dryrun](#input\_dryrun) | Defines if lambda runs on dryRunMode or if does actual changes | `string` | `"true"` | no |
| <a name="input_elb_cleanup_lambda_schedule"></a> [elb\_cleanup\_lambda\_schedule](#input\_elb\_cleanup\_lambda\_schedule) | A rate expression starts when you create the scheduled event rule, and then runs on its defined schedule. | `string` | `"rate(7 days)"` | no |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | The list of the private subnet IDs are used by elb-cleanup lambda | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of VPC is used by the elb-cleanup lamda | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->