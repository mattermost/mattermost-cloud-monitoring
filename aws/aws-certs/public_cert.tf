### Public AWS ACM certificate ###

resource "aws_acm_certificate" "pub_cert" {
  domain_name       = "*.${var.pub_domain}"
  validation_method = "DNS"

  tags = merge({
    Name = ".${var.pub_domain}"
    }, var.public_tags
  )
  lifecycle {
    create_before_destroy = true
  }
}
