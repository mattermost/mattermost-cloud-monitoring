### Public AWS ACM certificate ###

resource "aws_acm_certificate" "pub_cert" {
  domain_name       = "*.${var.pub_domain}"
  validation_method = "DNS"

  tags = merge({
    Name = ".${var.pub_domain}"
    }, var.public_tags
  )
}

resource "aws_acm_certificate_validation" "pub_cert_validation" {
  certificate_arn         = aws_acm_certificate.pub_cert.arn
  validation_record_fqdns = [aws_route53_record.pub_cert_validation.fqdn]
}

resource "aws_route53_record" "pub_cert_validation" {
  zone_id = var.pub_validation_acm_zoneid
  name    = aws_acm_certificate.pub_cert.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.pub_cert.domain_validation_options.0.resource_record_type
  ttl     = "300"
  records = [aws_acm_certificate.pub_cert.domain_validation_options.0.resource_record_value]
}
