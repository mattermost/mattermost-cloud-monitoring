output "private_cert_domain" {
  value = aws_acm_certificate.private_cert.domain_name
}

output "public_cert_domain" {
  value = aws_acm_certificate.pub_cert.domain_name
}
