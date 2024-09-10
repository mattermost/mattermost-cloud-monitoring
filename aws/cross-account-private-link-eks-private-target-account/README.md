## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.41.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.41.0 |
| <a name="provider_aws.target"></a> [aws.target](#provider\_aws.target) | >= 5.41.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eks_cluster.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_iam_policy.target_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.target_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.target_role_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.proxy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_lb.nlb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.nlb_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_vpc_endpoint_service.endpoint_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_service) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.existing_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_lb.existing_nlb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_principals"></a> [allowed\_principals](#input\_allowed\_principals) | List of AWS principals allowed to access the endpoint service | `list(string)` | n/a | yes |
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | AMI ID for the proxy instance | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster to create or validate | `string` | n/a | yes |
| <a name="input_create_private_endpoint"></a> [create\_private\_endpoint](#input\_create\_private\_endpoint) | Flag to indicate if the EKS cluster should have a private endpoint only | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Type of EC2 instance | `string` | `"t2.micro"` | no |
| <a name="input_listener_port"></a> [listener\_port](#input\_listener\_port) | Listener port for NLB | `number` | `443` | no |
| <a name="input_nlb_name"></a> [nlb\_name](#input\_nlb\_name) | Name of the Network Load Balancer | `string` | n/a | yes |
| <a name="input_proxy_security_group_ids"></a> [proxy\_security\_group\_ids](#input\_proxy\_security\_group\_ids) | Security Groups for the proxy instance | `list(string)` | n/a | yes |
| <a name="input_proxy_subnet_id"></a> [proxy\_subnet\_id](#input\_proxy\_subnet\_id) | Subnet ID where the instance will be deployed | `string` | n/a | yes |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Security Groups for the EKS cluster | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Subnets used by the EKS cluster | `list(string)` | n/a | yes |
| <a name="input_target_group_name"></a> [target\_group\_name](#input\_target\_group\_name) | Name of the target group for NLB | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID where the EKS cluster and proxy will be deployed | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_endpoint_service_name"></a> [endpoint\_service\_name](#output\_endpoint\_service\_name) | Endpoint Service Name |
