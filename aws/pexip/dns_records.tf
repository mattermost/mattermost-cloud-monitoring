resource "cloudflare_dns_record" "pexip_conference" {
  zone_id = var.cloudflare_zone_id
  name    = var.conference_cloudflare_record_name
  content = aws_eip.pexip_conference_eip.public_ip
  type    = "A"
  proxied = true
}

data "aws_route53_zone" "private_zone" {
  name         = "internal.${var.environment}.cloud.mattermost.com"
  private_zone = true
}

resource "aws_route53_record" "pexip_management" {
  zone_id = data.aws_route53_zone.private_zone.zone_id
  name    = "${var.management_route53_record_name}.${data.aws_route53_zone.private_zone.name}"
  type    = "A"
  alias {
    name                   = aws_elb.pexip_management_elb.dns_name
    zone_id                = aws_elb.pexip_management_elb.zone_id
    evaluate_target_health = true
  }
}
