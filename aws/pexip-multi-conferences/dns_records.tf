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
  count        = var.management_public ? 0 : 1
  name         = "internal.${var.environment}.cloud.mattermost.com"
  private_zone = true
}

resource "aws_route53_record" "pexip_management" {
  count   = var.management_public ? 0 : 1
  zone_id = data.aws_route53_zone.private_zone[0].zone_id
  name    = "${var.management_route53_record_name}.${data.aws_route53_zone.private_zone[0].name}"
  type    = "A"
  alias {
    name                   = aws_elb.pexip_management_elb.dns_name
    zone_id                = aws_elb.pexip_management_elb.zone_id
    evaluate_target_health = true
  }
}

resource "cloudflare_dns_record" "pexip_management" {
  count   = var.management_public ? 1 : 0
  zone_id = var.cloudflare_zone_id
  name    = var.management_public_dns_name
  content = aws_elb.pexip_management_elb.dns_name
  type    = "CNAME"
  proxied = var.initial_configuration ? false : true
  ttl     = var.initial_configuration ? 300 : 1
  comment = "Pexip management node DNS record"

  lifecycle {
    precondition {
      condition     = trimspace(var.management_public_dns_name) != ""
      error_message = "management_public_dns_name must be set when management_public is true."
    }
  }
}
