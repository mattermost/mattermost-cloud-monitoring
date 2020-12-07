
### GitLab cert ###
resource "aws_acm_certificate" "gitlab_cert" {
  domain_name       = "*.${var.gitlab_domain}"
  validation_method = "DNS"

  tags = {
    Name = ".${var.gitlab_domain}"
  }
}

resource "aws_acm_certificate_validation" "gitlab_cert_validation" {
  certificate_arn         = aws_acm_certificate.gitlab_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.gitlab_validation : record.fqdn]
}

resource "aws_route53_record" "gitlab_validation" {
  for_each = {
    for dvo in aws_acm_certificate.gitlab_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = var.validation_hosted_zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = "300"
  records = [each.value.record]
}

