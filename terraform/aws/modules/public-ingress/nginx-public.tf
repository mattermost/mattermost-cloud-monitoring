data "aws_acm_certificate" "public_core" {
  domain      = "*.core.cloud.mattermost.com"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

resource "kubernetes_namespace" "public_nginx" {
  metadata {
    name = "nginx-public"
  }
}

resource "helm_release" "public_nginx" {
  name      = "public"
  chart     = "stable/nginx-ingress"
  namespace = "nginx-public"
  values = [
    "${file("../../../modules/public-ingress/nginx_values.yaml")}"
  ]

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-cert"
    value = data.aws_acm_certificate.public_core.arn
  }

  depends_on = [
    data.aws_acm_certificate.public_core,
    kubernetes_namespace.public_nginx,
  ]

  timeout = 1200

}
