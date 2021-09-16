data "kubernetes_service" "nginx-private" {
  metadata {
    name      = "nginx-internal-ingress-nginx-controller"
    namespace = "nginx-internal"
  }
}

data "kubernetes_service" "nginx-public" {
  metadata {
    name      = "nginx-ingress-nginx-controller"
    namespace = "nginx"
  }
}

#Private records
resource "aws_route53_record" "prometheus" {
  zone_id = var.private_hosted_zoneid
  name    = "prometheus"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service.nginx-private.status.0.load_balancer.0.ingress.0.hostname]
}

resource "aws_route53_record" "grafana" {
  zone_id = var.private_hosted_zoneid
  name    = "grafana"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service.nginx-private.status.0.load_balancer.0.ingress.0.hostname]
}

resource "aws_route53_record" "database_factory" {
  zone_id = var.private_hosted_zoneid
  name    = "dbfactory"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service.nginx-private.status.0.load_balancer.0.ingress.0.hostname]
}

resource "aws_route53_record" "thanos" {
  zone_id = var.private_hosted_zoneid
  name    = "thanos"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service.nginx-private.status.0.load_balancer.0.ingress.0.hostname]
}

resource "aws_route53_record" "blackbox" {
  zone_id = var.private_hosted_zoneid
  name    = "blackbox"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service.nginx-private.status.0.load_balancer.0.ingress.0.hostname]
}

resource "aws_route53_record" "argocd" {
  zone_id = var.private_hosted_zoneid
  name    = "argocd"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service.nginx-private.status.0.load_balancer.0.ingress.0.hostname]
}

resource "aws_route53_record" "provisioner" {
  zone_id = var.private_hosted_zoneid
  name    = "provisioner"
  type    = "CNAME"
  ttl     = "60"
  records = [data.kubernetes_service.nginx-private.status.0.load_balancer.0.ingress.0.hostname]
}

resource "aws_route53_record" "awat" {
  count = var.enable_awat_record ? 1 : 0

  zone_id = var.private_hosted_zoneid
  name    = "awat"
  type    = "CNAME"
  ttl     = "60"
  records = [data.kubernetes_service.nginx-private.status.0.load_balancer.0.ingress.0.hostname]
}

resource "aws_route53_record" "customer_web_server" {
  count = var.enable_portal_public_r53_record ? 1 : 0

  zone_id = var.public_hosted_zoneid
  name    = "portal"
  type    = "CNAME"
  ttl     = "60"
  records = [data.kubernetes_service.nginx-public.status.0.load_balancer.0.ingress.0.hostname]
}

resource "aws_route53_record" "customer_web_server_internal" {
  count = var.enable_portal_private_r53_record ? 1 : 0

  zone_id = var.private_hosted_zoneid
  name    = "portal"
  type    = "CNAME"
  ttl     = "60"
  records = [data.kubernetes_service.nginx-private.status.0.load_balancer.0.ingress.0.hostname]
}

resource "aws_route53_record" "customer_web_server_api_internal" {
  count = var.enable_portal_internal_r53_record ? 1 : 0

  zone_id = var.private_hosted_zoneid
  name    = "api"
  type    = "CNAME"
  ttl     = "60"
  records = [data.kubernetes_service.nginx-private.status.0.load_balancer.0.ingress.0.hostname]
}

resource "aws_route53_record" "chimera" {
  count = var.enable_chimera_record ? 1 : 0

  zone_id = var.public_hosted_zoneid
  name    = "chimera"
  type    = "CNAME"
  ttl     = "60"
  records = [data.kubernetes_service.nginx-public.status.0.load_balancer.0.ingress.0.hostname]
}

resource "aws_route53_record" "chaos_mesh" {
  zone_id = var.private_hosted_zoneid
  name    = "chaos"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service.nginx-private.status.0.load_balancer.0.ingress.0.hostname]
}

resource "aws_route53_record" "kubecost" {
  count = var.enable_kubecost_record ? 1 : 0

  zone_id = var.private_hosted_zoneid
  name    = "kubecost"
  type    = "CNAME"
  ttl     = "60"
  records = [data.kubernetes_service.nginx-private.status.0.load_balancer.0.ingress.0.hostname]
}
