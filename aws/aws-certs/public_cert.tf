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
  validation_record_fqdns = [for record in aws_route53_record.pub_cert_validation : record.fqdn]
}

resource "aws_route53_record" "pub_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.pub_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = var.pub_validation_acm_zoneid
  name    = each.value.name
  type    = each.value.type
  ttl     = "300"
  records = [each.value.record]
}
