resource "aws_route53_record" "pritunl_record" {
  zone_id = var.public_hosted_zoneid
  name    = var.name
  type    = "A"
  alias {
    name                   = aws_lb.pritunl_nlb.dns_name
    zone_id                = aws_lb.pritunl_nlb.zone_id
    evaluate_target_health = true
  }
}
