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
| [aws_acm_certificate.private_cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate.pub_cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.private_cert_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_route53_record.private_cert_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alternative_cert_domains"></a> [alternative\_cert\_domains](#input\_alternative\_cert\_domains) | The alternative cert domains to be added | `list(string)` | n/a | yes |
| <a name="input_priv_domain"></a> [priv\_domain](#input\_priv\_domain) | The domain name for ACM certificate for a private zone | `string` | n/a | yes |
| <a name="input_private_tags"></a> [private\_tags](#input\_private\_tags) | The tags which will attached in the private ACM certificate | `map(string)` | n/a | yes |
| <a name="input_pub_domain"></a> [pub\_domain](#input\_pub\_domain) | The domain name for ACM certificate for a public zone | `string` | n/a | yes |
| <a name="input_public_tags"></a> [public\_tags](#input\_public\_tags) | The tags which will attached in the public ACM certificate | `map(string)` | n/a | yes |
| <a name="input_validation_acm_zoneid"></a> [validation\_acm\_zoneid](#input\_validation\_acm\_zoneid) | The Hosted Zone ID for certs validation | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_cert_domain"></a> [private\_cert\_domain](#output\_private\_cert\_domain) | n/a |
| <a name="output_public_cert_domain"></a> [public\_cert\_domain](#output\_public\_cert\_domain) | n/a |
