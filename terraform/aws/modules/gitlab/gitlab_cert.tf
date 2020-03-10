
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
  validation_record_fqdns = [aws_route53_record.gitlab_validation.fqdn]
}

resource "aws_route53_record" "gitlab_validation" {
  zone_id = var.validation_hosted_zone_id
  name    = aws_acm_certificate.gitlab_cert.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.gitlab_cert.domain_validation_options.0.resource_record_type
  ttl     = "300"
  records = [aws_acm_certificate.gitlab_cert.domain_validation_options.0.resource_record_value]
}

