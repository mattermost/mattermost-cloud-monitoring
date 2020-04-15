data "kubernetes_service" "internal_nginx" {
  metadata {
    name      = "internal-nginx-ingress-controller"
    namespace = "nginx-internal"
  }
  depends_on = [
    helm_release.internal_nginx,
    helm_release.atlantis,
  ]
}

data "aws_elb_hosted_zone_id" "main" {}

resource "aws_route53_record" "atlantis" {
  zone_id = var.private_hosted_zoneid
  name    = "atlantis"
  type    = "CNAME"
  ttl     = "60"
  records = [data.kubernetes_service.internal_nginx.load_balancer_ingress.0.hostname]

  depends_on = [
    helm_release.internal_nginx,
    helm_release.atlantis,
  ]
}
