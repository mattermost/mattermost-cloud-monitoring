### AWS ACM wildcard certificate ###

resource "aws_acm_certificate" "wildcard_cert" {
  domain_name       = "*.${var.domain}"
  validation_method = "DNS"

  tags = {
    Name = ".${var.domain}"
  }
}

resource "aws_acm_certificate_validation" "wildcard_cert_validation" {
  certificate_arn         = aws_acm_certificate.wildcard_cert.arn
  validation_record_fqdns = [aws_route53_record.wildcard_validation.fqdn]
}

resource "aws_route53_record" "wildcard_validation" {
  zone_id = var.validation_acm_zoneid
  name    = aws_acm_certificate.wildcard_cert.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.wildcard_cert.domain_validation_options.0.resource_record_type
  ttl     = "300"
  records = [aws_acm_certificate.wildcard_cert.domain_validation_options.0.resource_record_value]
}
