## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.41.0 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | ~> 5.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.41.0 |
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | ~> 5.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.pexip_conference_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_eip_association.pexip_conference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip_association) | resource |
| [aws_elb.pexip_conference_elb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elb) | resource |
| [aws_elb.pexip_management_elb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elb) | resource |
| [aws_instance.pexip_conference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.pexip_management](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_network_interface.pexip_conference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |
| [aws_network_interface.pexip_management](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |
| [aws_route53_record.pexip_management](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.pexip_conference_elb_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.pexip_conference_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.pexip_management_elb_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.pexip_management_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.pexip_conference_egress_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.pexip_conference_elb_bootstrap](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.pexip_conference_elb_egress_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.pexip_conference_elb_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.pexip_conference_elb_sip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.pexip_conference_elb_sip_tls](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.pexip_conference_elb_to_conf_443](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.pexip_conference_elb_to_conf_5061](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.pexip_conference_elb_to_conf_8443](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.pexip_conference_from_elb_443](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.pexip_conference_from_elb_5061](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.pexip_conference_from_elb_8443](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.pexip_conference_from_management_esp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.pexip_conference_from_management_udp_500](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.pexip_conference_udp_ports](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.pexip_conference_vpn_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.pexip_management_egress_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.pexip_management_elb_egress_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.pexip_management_elb_https_vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.pexip_management_elb_to_mgmt_443](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.pexip_management_from_conference_esp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.pexip_management_from_conference_udp_500](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.pexip_management_from_elb_443](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.pexip_management_initial_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [cloudflare_dns_record.pexip_conference](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record) | resource |
| [aws_route53_zone.private_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudflare_zone_id"></a> [cloudflare\_zone\_id](#input\_cloudflare\_zone\_id) | The Cloudflare zone ID provided | `string` | n/a | yes |
| <a name="input_conference_nodes"></a> [conference\_nodes](#input\_conference\_nodes) | Map of conference nodes with their properties | <pre>map(object({<br/>    dns_name   = string<br/>    ec2_type   = string<br/>    private_ip = string<br/>    ami_id     = string<br/>  }))</pre> | <pre>{<br/>  "example": {<br/>    "ami_id": "ami-0d48fecb4209bb660",<br/>    "dns_name": "example.mattermost.com",<br/>    "ec2_type": "c6i.xlarge",<br/>    "private_ip": "10.0.1.11"<br/>  },<br/>  "random": {<br/>    "ami_id": "ami-0d48fecb4209bb660",<br/>    "dns_name": "random.mattermost.com",<br/>    "ec2_type": "c6i.large",<br/>    "private_ip": "10.0.1.10"<br/>  }<br/>}</pre> | no |
| <a name="input_custom_management_ec2_ami"></a> [custom\_management\_ec2\_ami](#input\_custom\_management\_ec2\_ami) | Customized with MM configuration Pexip AMI for management node | `string` | n/a | yes |
| <a name="input_ec2_key_pair"></a> [ec2\_key\_pair](#input\_ec2\_key\_pair) | The key pair that will be used for ssh to EC2 instances of Pexip nodes | `string` | n/a | yes |
| <a name="input_elb_ssl_certificate_arn_internal"></a> [elb\_ssl\_certificate\_arn\_internal](#input\_elb\_ssl\_certificate\_arn\_internal) | ARN of the SSL certificate to be used with the internal ELB | `string` | n/a | yes |
| <a name="input_elb_ssl_certificate_arn_public"></a> [elb\_ssl\_certificate\_arn\_public](#input\_elb\_ssl\_certificate\_arn\_public) | ARN of the SSL certificate to be used with the public ELB | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name that pexip will be deployed | `string` | n/a | yes |
| <a name="input_initial_configuration"></a> [initial\_configuration](#input\_initial\_configuration) | A boolean variable to control the initial configuration of Pexip setup, when true official AMI will be deployed and key-pairs will be added to EC2 nodes | `bool` | `true` | no |
| <a name="input_management_ec2_type"></a> [management\_ec2\_type](#input\_management\_ec2\_type) | The EC2 instance type for Pexip management node | `string` | n/a | yes |
| <a name="input_management_private_ips"></a> [management\_private\_ips](#input\_management\_private\_ips) | List of the private IPs of the Pexip management node | `list(string)` | n/a | yes |
| <a name="input_management_route53_record_name"></a> [management\_route53\_record\_name](#input\_management\_route53\_record\_name) | The DNS name for the Pexip management node | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | `"pexip"` | no |
| <a name="input_official_pexip_conference_ec2_ami"></a> [official\_pexip\_conference\_ec2\_ami](#input\_official\_pexip\_conference\_ec2\_ami) | The official AMI 686087431763/Pexip Infinity Conference Node 37.0.0 (build 80989.0.0) | `string` | `"ami-0d48fecb4209bb660"` | no |
| <a name="input_official_pexip_management_ec2_ami"></a> [official\_pexip\_management\_ec2\_ami](#input\_official\_pexip\_management\_ec2\_ami) | The official AMI 686087431763/Pexip Infinity Management Node 37.0.0 (build 80989.0.0) | `string` | `"ami-06a8e3534fc60c76b"` | no |
| <a name="input_private_subnet_id"></a> [private\_subnet\_id](#input\_private\_subnet\_id) | A private subnet ID for Pexip management node | `string` | n/a | yes |
| <a name="input_public_subnet_id"></a> [public\_subnet\_id](#input\_public\_subnet\_id) | A public subnet ID | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the vpc for the security group of Pexip | `string` | n/a | yes |
| <a name="input_vpn_ips"></a> [vpn\_ips](#input\_vpn\_ips) | List of the IPs for the VPN | `list(string)` | n/a | yes |

## Outputs

No outputs.
