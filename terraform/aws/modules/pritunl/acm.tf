
resource "aws_acm_certificate" "pritunl_cert" {
  domain_name       = "*.${var.domain}"
  validation_method = "DNS"

  tags = {
    Name = ".${var.domain}"
  }
}

resource "aws_acm_certificate_validation" "pritunl_cert_validation" {
  certificate_arn         = aws_acm_certificate.pritunl_cert.arn
  validation_record_fqdns = [aws_route53_record.pritunl_validation.fqdn]
}

resource "aws_route53_record" "pritunl_validation" {
  zone_id = var.public_hosted_zoneid
  name    = aws_acm_certificate.pritunl_cert.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.pritunl_cert.domain_validation_options.0.resource_record_type
  ttl     = "60"
  records = [aws_acm_certificate.pritunl_cert.domain_validation_options.0.resource_record_value]
}

