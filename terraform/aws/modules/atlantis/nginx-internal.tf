data "aws_acm_certificate" "internal_core" {
  domain      = "*.internal.core.cloud.mattermost.com"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

resource "kubernetes_namespace" "internal_nginx" {
  metadata {
    name = "nginx-internal"
  }
}

resource "helm_release" "internal_nginx" {
  name      = "internal"
  chart     = "stable/nginx-ingress"
  namespace = "nginx-internal"
  values = [
    "${file(var.nginx_internal_chart_values_directory)}"
  ]

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-cert"
    value = data.aws_acm_certificate.internal_core.arn
  }

  depends_on = [
    data.aws_acm_certificate.internal_core,
    kubernetes_namespace.internal_nginx,
  ]

  timeout = 1200

}
