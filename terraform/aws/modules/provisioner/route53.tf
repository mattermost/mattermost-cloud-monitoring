data "kubernetes_service" "nginx-internal" {
  metadata {
    name      = "nginx-ingress-nginx-controller-internal"
    namespace = "nginx"
  }
  depends_on = [
    helm_release.nginx-internal
  ]
}

#Private records
resource "aws_route53_record" "provisioner" {
  zone_id = var.private_hosted_zoneid
  name    = var.provisioner_name
  type    = "CNAME"
  ttl     = "60"
  records = [data.kubernetes_service.nginx-internal.load_balancer_ingress.0.hostname]
}
