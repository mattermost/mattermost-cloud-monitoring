# data "kubernetes_service" "gitlab_nginx" {
#   metadata {
#     name      = "gitlab-nginx-ingress-controller"
#     namespace = "gitlab"
#   }
#   depends_on = [
#     helm_release.gitlab,
#   ]
# }

# resource "aws_route53_record" "gitlab_record" {
#   zone_id = var.private_hosted_zoneid
#   name    = "gitlab"
#   type    = "CNAME"
#   ttl     = "60"
#   records = [data.kubernetes_service.gitlab_nginx.load_balancer_ingress.0.hostname]

#   depends_on = [
#     helm_release.gitlab,
#   ]
# }


# resource "aws_route53_record" "registry_record" {
#   zone_id = var.private_hosted_zoneid
#   name    = "registry"
#   type    = "CNAME"
#   ttl     = "60"
#   records = [data.kubernetes_service.gitlab_nginx.load_balancer_ingress.0.hostname]

#   depends_on = [
#     helm_release.gitlab,
#   ]
# }
