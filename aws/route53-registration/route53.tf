data "kubernetes_service" "nginx-private" {
  metadata {
    name      = var.kubernetes_service_nginx_private
    namespace = "nginx-internal"
  }
}

data "kubernetes_service" "nginx-public" {
  metadata {
    name      = var.kubernetes_service_nginx_public
    namespace = "nginx"
  }
}

#Private records
resource "aws_route53_record" "prometheus" {
  zone_id = var.private_hosted_zoneid
  name    = "prometheus"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service.nginx-private.status[0].load_balancer[0].ingress[0].hostname]
}

resource "aws_route53_record" "prometheus_alertmanager" {
  count = var.enable_alertmanager_r53_record ? 1 : 0

  zone_id = var.private_hosted_zoneid
  name    = "alertmanager"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service.nginx-private.status[0].load_balancer[0].ingress[0].hostname]
}

resource "aws_route53_record" "thanos" {
  zone_id = var.private_hosted_zoneid
  name    = "thanos"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service.nginx-private.status[0].load_balancer[0].ingress[0].hostname]
}

resource "aws_route53_record" "argocd" {
  zone_id = var.private_hosted_zoneid
  name    = "argocd"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service.nginx-private.status[0].load_balancer[0].ingress[0].hostname]
}

resource "aws_route53_record" "provisioner" {
  zone_id = var.private_hosted_zoneid
  name    = "provisioner"
  type    = "CNAME"
  ttl     = "60"
  records = [data.kubernetes_service.nginx-private.status[0].load_balancer[0].ingress[0].hostname]
}

resource "aws_route53_record" "awat" {
  count = var.enable_awat_record ? 1 : 0

  zone_id = var.private_hosted_zoneid
  name    = "awat"
  type    = "CNAME"
  ttl     = "60"
  records = [data.kubernetes_service.nginx-private.status[0].load_balancer[0].ingress[0].hostname]
}

resource "cloudflare_record" "customer_web_server" {
  count = var.enabled_cloudflare_customer_web_server ? 1 : 0

  zone_id = var.cloudflare_zone_id
  name    = var.cws_cloudflare_record_name
  value   = data.kubernetes_service.nginx-public.status[0].load_balancer[0].ingress[0].hostname
  type    = "CNAME"
  proxied = true
}

resource "aws_route53_record" "customer_web_server" {
  count = var.enable_portal_public_r53_record ? 1 : 0

  zone_id = var.public_hosted_zoneid
  name    = "portal"
  type    = "CNAME"
  ttl     = "60"
  records = [var.enabled_cloudflare_customer_web_server ? var.cloudflare_customer_webserver_cdn : data.kubernetes_service.nginx-public.status[0].load_balancer[0].ingress[0].hostname]
}

resource "aws_route53_record" "customer_web_server_internal" {
  count = var.enable_portal_private_r53_record ? 1 : 0

  zone_id = var.private_hosted_zoneid
  name    = "portal"
  type    = "CNAME"
  ttl     = "60"
  records = [data.kubernetes_service.nginx-private.status[0].load_balancer[0].ingress[0].hostname]
}

resource "aws_route53_record" "customer_web_server_api_internal" {
  count = var.enable_portal_internal_r53_record ? 1 : 0

  zone_id = var.private_hosted_zoneid
  name    = "api"
  type    = "CNAME"
  ttl     = "60"
  records = [data.kubernetes_service.nginx-private.status[0].load_balancer[0].ingress[0].hostname]
}

resource "cloudflare_record" "chimera" {
  count = var.enabled_cloudflare_chimera ? 1 : 0

  zone_id = var.cloudflare_zone_id
  name    = var.chimera_cloudflare_record_name
  value   = data.kubernetes_service.nginx-public.status[0].load_balancer[0].ingress[0].hostname
  type    = "CNAME"
  proxied = true
}

resource "aws_route53_record" "chimera" {
  count = var.enable_chimera_record ? 1 : 0

  zone_id = var.public_hosted_zoneid
  name    = "chimera"
  type    = "CNAME"
  ttl     = "60"
  records = [var.enabled_cloudflare_chimera ? var.cloudflare_chimera_cdn : data.kubernetes_service.nginx-public.status[0].load_balancer[0].ingress[0].hostname]
}

resource "aws_route53_record" "chaos_mesh" {
  count = var.enable_chaos_record ? 1 : 0

  zone_id = var.private_hosted_zoneid
  name    = "chaos"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service.nginx-private.status[0].load_balancer[0].ingress[0].hostname]
}

resource "aws_route53_record" "push_proxy" {
  count = var.enable_push_proxy_record ? 1 : 0

  zone_id = var.private_hosted_zoneid
  name    = "push"
  type    = "CNAME"
  ttl     = "60"
  records = [data.kubernetes_service.nginx-private.status[0].load_balancer[0].ingress[0].hostname]
}

resource "aws_route53_record" "loki_gateway" {
  count = var.enable_loki_gateway ? 1 : 0

  zone_id = var.private_hosted_zoneid
  name    = "loki-gateway"
  type    = "CNAME"
  ttl     = "60"
  records = [data.kubernetes_service.nginx-private.status[0].load_balancer[0].ingress[0].hostname]
}

resource "aws_route53_record" "loki_frontend" {
  count = var.enable_loki_frontend ? 1 : 0

  zone_id = var.private_hosted_zoneid
  name    = "loki-frontend"
  type    = "CNAME"
  ttl     = "60"
  records = [data.kubernetes_service.nginx-private.status[0].load_balancer[0].ingress[0].hostname]
}

resource "aws_route53_record" "loki_developers_gateway" {
  count = var.enable_loki_developers_gateway ? 1 : 0

  zone_id = var.private_hosted_zoneid
  name    = "loki-developers-gateway"
  type    = "CNAME"
  ttl     = "60"
  records = [data.kubernetes_service.nginx-private.status[0].load_balancer[0].ingress[0].hostname]
}

resource "aws_route53_record" "loki_developers_frontend" {
  count = var.enable_loki_developers_frontend ? 1 : 0

  zone_id = var.private_hosted_zoneid
  name    = "loki-developers-frontend"
  type    = "CNAME"
  ttl     = "60"
  records = [data.kubernetes_service.nginx-private.status[0].load_balancer[0].ingress[0].hostname]
}


resource "aws_route53_record" "elrond" {
  count = var.enable_elrond_private_r53_record ? 1 : 0

  zone_id = var.private_hosted_zoneid
  name    = "elrond"
  type    = "CNAME"
  ttl     = "60"
  records = [data.kubernetes_service.nginx-private.status[0].load_balancer[0].ingress[0].hostname]
}
