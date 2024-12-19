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
| [aws_route53_record.rds_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.rds_writer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_private_hosted_zoneid"></a> [private\_hosted\_zoneid](#input\_private\_hosted\_zoneid) | The ID of the Route53 private hosted zone | `string` | n/a | yes |
| <a name="input_rds_reader_hostnames"></a> [rds\_reader\_hostnames](#input\_rds\_reader\_hostnames) | The RDS reader hostname, must be 3 elements. The first element is the generic reader hostname, the second is the primary reader, and the third is the secondary reader. | `list(string)` | n/a | yes |
| <a name="input_rds_reader_records"></a> [rds\_reader\_records](#input\_rds\_reader\_records) | The RDS reader records, must be 3 elements. The first element is the generic reader record, the second is the primary reader, and the third is the secondary reader. | `list(string)` | <pre>[<br/>  "community-db-ro",<br/>  "community-db-reader1",<br/>  "community-db-reader2"<br/>]</pre> | no |
| <a name="input_rds_writer_hostname"></a> [rds\_writer\_hostname](#input\_rds\_writer\_hostname) | The RDS writer hostname | `string` | n/a | yes |

## Outputs

No outputs.
