
resource "aws_acm_certificate" "pritunl_cert" {
  domain_name       = "*.${var.domain}"
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = ".${var.domain}"
  }
}

resource "aws_acm_certificate_validation" "pritunl_cert_validation" {
  certificate_arn         = aws_acm_certificate.pritunl_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.pritunl_validation : record.fqdn]
}

resource "aws_route53_record" "pritunl_validation" {
  for_each = {
    for dvo in aws_acm_certificate.pritunl_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = var.public_hosted_zoneid
  name    = each.value.name
  type    = each.value.type
  ttl     = "60"
  records = [each.value.record]
}
