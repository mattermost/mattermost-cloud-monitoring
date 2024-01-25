<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.61.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.61.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.bind_arm_autoscale](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_autoscaling_group.bind_autoscale](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_autoscaling_lifecycle_hook.bind_lifecycle_hook](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_lifecycle_hook) | resource |
| [aws_autoscaling_lifecycle_hook.bind_lifecycle_hook_arm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_lifecycle_hook) | resource |
| [aws_cloudwatch_event_rule.autoscaling_bind_updates](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.bind_server_autoscaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_metric_alarm.low_free_memory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.low_free_storage_space](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_iam_instance_profile.bind-server-instance-profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.bind-server-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.bind_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.EC2Access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.AWSLambdaBasicExecutionRole](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.bind-cloudwatch-agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_key_pair.bind](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_lambda_function.bind_server_network_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.allow_cloudwatch_to_call_bind](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_launch_template.bind_arm_launch_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_launch_template.bind_launch_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_network_interface.bind_network_interface](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |
| [aws_security_group.bind_lambda_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.bind_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami"></a> [ami](#input\_ami) | Custom AMI to use for instances. | `string` | n/a | yes |
| <a name="input_arm_ami"></a> [arm\_ami](#input\_arm\_ami) | Custom AMI to use for ARM/Graviton instances. | `string` | n/a | yes |
| <a name="input_arm_desired_size"></a> [arm\_desired\_size](#input\_arm\_desired\_size) | The desired number of arm nodes in the arm node group | `number` | `0` | no |
| <a name="input_arm_instance_type"></a> [arm\_instance\_type](#input\_arm\_instance\_type) | The instance type used for the arm nodes in the node group | `string` | n/a | yes |
| <a name="input_arm_max_size"></a> [arm\_max\_size](#input\_arm\_max\_size) | The maximum number of arm nodes in the arm node group | `number` | `0` | no |
| <a name="input_arm_min_size"></a> [arm\_min\_size](#input\_arm\_min\_size) | The minimum number of arm nodes in the arm node group | `number` | `0` | no |
| <a name="input_cidr_blocks"></a> [cidr\_blocks](#input\_cidr\_blocks) | The CIDR block to allow network traffic | `list(string)` | n/a | yes |
| <a name="input_desired_size"></a> [desired\_size](#input\_desired\_size) | n/a | `number` | `3` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment will be created | `string` | n/a | yes |
| <a name="input_hosts_list"></a> [hosts\_list](#input\_hosts\_list) | The list of bind servers hosts | `list(string)` | `[]` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Type of instance to run the DNS servers | `string` | `"t3.nano"` | no |
| <a name="input_lambda_s3_bucket"></a> [lambda\_s3\_bucket](#input\_lambda\_s3\_bucket) | The S3 bucket where the lambda function is stored | `string` | n/a | yes |
| <a name="input_lambda_s3_key"></a> [lambda\_s3\_key](#input\_lambda\_s3\_key) | The S3 key where the lambda function is stored | `string` | n/a | yes |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | n/a | `number` | `3` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | n/a | `number` | `3` | no |
| <a name="input_name"></a> [name](#input\_name) | Name prefix of the instances (will have server number appended).  One of 'name' or 'names' may be specified. | `string` | `"dns"` | no |
| <a name="input_private_ips"></a> [private\_ips](#input\_private\_ips) | Private IP addresses of servers, which must be within the subnets specified in 'subnet\_ids' (in the same order).  These are specified explicitly since it's desirable to be able to replace a DNS server without its IP address changing.  Our convention is to use the first unreserved address in the subnet (which is to say, the '+4' address). | `list(string)` | n/a | yes |
| <a name="input_ssh_key_public"></a> [ssh\_key\_public](#input\_ssh\_key\_public) | The contect of the SSH public key | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Subnets to run servers in | `list(string)` | n/a | yes |
| <a name="input_subnet_ids_arm"></a> [subnet\_ids\_arm](#input\_subnet\_ids\_arm) | Subnets to run arm servers in | `list(string)` | n/a | yes |
| <a name="input_teleport_cidr"></a> [teleport\_cidr](#input\_teleport\_cidr) | The Teleport CIDR block to allow access | `list(string)` | n/a | yes |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | The size of the volume for DNS Bind Servers | `number` | `8` | no |
| <a name="input_volume_type"></a> [volume\_type](#input\_volume\_type) | The type of the volume for DNS Bind Servers | `string` | `"gp2"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID runs in | `string` | n/a | yes |
| <a name="input_vpn_cidr"></a> [vpn\_cidr](#input\_vpn\_cidr) | The VPN CIDR block to allow access | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bind_sg"></a> [bind\_sg](#output\_bind\_sg) | The Bind server SG |
| <a name="output_private_ips"></a> [private\_ips](#output\_private\_ips) | Private IP address(es) of the DNS server(s) |
<!-- END_TF_DOCS -->