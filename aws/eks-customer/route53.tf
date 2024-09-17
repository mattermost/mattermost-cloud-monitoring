locals {
  enabled_dns_names = flatten([
    for utility in var.utilities :
    utility.internal_dns.enabled ? utility.internal_dns.dns_name : []
  ])
}

# resource "time_sleep" "wait_for_elb" {
#   create_duration = "8m"

#   depends_on = [null_resource.deploy-utilites]
# }

resource "aws_route53_record" "internal" {
  for_each = toset(local.enabled_dns_names)

  zone_id = data.aws_route53_zone.internal.zone_id
  name    = strcontains(each.value, "grpc") ? "${module.eks.cluster_name}-${each.value}" : "${module.eks.cluster_name}.${each.value}"
  type    = "CNAME"
  ttl     = 300
  records = [data.aws_lb.internal.dns_name]

  weighted_routing_policy {
    weight = 1
  }

  set_identifier = strcontains(each.value, "grpc") ? "${module.eks.cluster_name}-${each.value}" : "${module.eks.cluster_name}.${each.value}"

  # depends_on = [time_sleep.wait_for_elb]
}
