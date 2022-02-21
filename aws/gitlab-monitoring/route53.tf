data "kubernetes_service" "nginx-private" {
  metadata {
    name      = "nginx-internal-ingress-nginx-controller"
    namespace = "nginx-internal"
  }
}

#Private records
resource "aws_route53_record" "prometheus" {
  zone_id = var.private_hosted_zoneid
  name    = "prometheus"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service.nginx-private.load_balancer_ingress.0.hostname]
}

resource "aws_route53_record" "grafana" {
  zone_id = var.private_hosted_zoneid
  name    = "grafana"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service.nginx-private.load_balancer_ingress.0.hostname]
}
