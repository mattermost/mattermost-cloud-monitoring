### Private AWS ACM certificate ###

resource "aws_acm_certificate" "private_cert" {
  domain_name               = "*.${var.priv_domain}"
  subject_alternative_names = var.alternative_cert_domains
  validation_method         = "DNS"

  tags = merge({
    Name = ".${var.priv_domain}"
    }, var.private_tags
  )
}

resource "aws_acm_certificate_validation" "private_cert_validation" {
  certificate_arn         = aws_acm_certificate.private_cert.arn
  validation_record_fqdns = aws_route53_record.private_cert_validations.*.fqdn
}

resource "aws_route53_record" "private_cert_validations" {
  count = (length(var.alternative_cert_domains) + 1)

  zone_id = var.validation_acm_zoneid
  name    = element(aws_acm_certificate.private_cert.domain_validation_options.*.resource_record_name, count.index)
  type    = element(aws_acm_certificate.private_cert.domain_validation_options.*.resource_record_type, count.index)
  ttl     = "300"
  records = [element(aws_acm_certificate.private_cert.domain_validation_options.*.resource_record_value, count.index)]
}
