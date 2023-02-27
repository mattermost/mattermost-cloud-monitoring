data "kubernetes_service" "internal_nginx" {
  metadata {
    name      = "nginx-internal-ingress-nginx-controller"
    namespace = "nginx-internal"
  }
}

resource "aws_route53_record" "atlantis" {
  zone_id = var.private_hosted_zoneid
  name    = "atlantis"
  type    = "CNAME"
  ttl     = "60"
  records = [data.kubernetes_service.internal_nginx.status[0].load_balancer[0].ingress[0].hostname]
}
