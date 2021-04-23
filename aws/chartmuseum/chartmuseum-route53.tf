data "kubernetes_service" "internal_nginx" {
  metadata {
    name      = "internal-nginx-ingress-controller"
    namespace = "nginx-internal"
  }
  depends_on = [
    helm_release.chartmuseum,
  ]
}

resource "aws_route53_record" "chartmuseum" {
  zone_id = var.private_hosted_zoneid
  name    = "chartmuseum"
  type    = "CNAME"
  ttl     = "60"
  records = [data.kubernetes_service.internal_nginx.load_balancer_ingress.0.hostname]

  depends_on = [
    helm_release.chartmuseum
  ]
}
