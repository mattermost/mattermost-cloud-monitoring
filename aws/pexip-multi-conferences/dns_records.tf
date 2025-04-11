resource "cloudflare_dns_record" "pexip_conference" {
  for_each = var.conference_nodes

  zone_id = var.cloudflare_zone_id
  name    = each.value.dns_name
  content = aws_elb.pexip_conference_elb[each.key].dns_name
  type    = "CNAME"
  proxied = true
  ttl     = 1 # 1 means 'automatic' since we're using proxied=true
  comment = "Pexip conference node DNS record"
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
