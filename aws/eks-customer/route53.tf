locals {
  enabled_dns_names = flatten([
    for utility in var.utilities :
    utility.internal_dns.enabled ? utility.internal_dns.dns_name : []
  ])
}

resource "aws_route53_record" "internal" {
  for_each = toset(local.enabled_dns_names)

  zone_id = data.aws_route53_zone.internal.zone_id
  name    = strcontains(each.value, "grpc") ? "${module.eks.cluster_name}-${each.value}" : "${module.eks.cluster_name}.${each.value}"
  type    = "CNAME"
  ttl     = 300
  records = strcontains(each.value, "grpc") ? [data.aws_lb.thanos-query-grpc.dns_name] : [data.aws_lb.internal.dns_name]

  weighted_routing_policy {
    weight = 1
  }

  set_identifier = "${module.eks.cluster_name}.${each.value}"
}
