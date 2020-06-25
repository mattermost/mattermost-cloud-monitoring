data "kubernetes_service" "nginx-internal" {
  metadata {
    name      = "mattermost-cm-nginx-internal-nginx-ingress-controller"
    namespace = "network"
  }
}

#Private records
resource "aws_route53_record" "provisioner" {
  zone_id = var.private_hosted_zoneid
  name    = "provisioner"
  type    = "CNAME"
  ttl     = "60"
  records = [data.kubernetes_service.nginx-internal.load_balancer_ingress.0.hostname]
}
