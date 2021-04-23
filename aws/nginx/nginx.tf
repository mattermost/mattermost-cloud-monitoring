data "aws_acm_certificate" "public" {
  domain      = var.public_domain_certificate
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

resource "kubernetes_namespace" "nginx" {
  metadata {
    name = "nginx"
  }
}

resource "helm_release" "nginx" {
  name       = "nginx"
  chart      = "ingress-nginx"
  version    = var.nginx_chart_version
  repository = "https://kubernetes.github.io/ingress-nginx/"
  namespace  = "nginx"
  values = [
    file("../../../../chart-values/nginx_values.yaml")
  ]

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-cert"
    value = data.aws_acm_certificate.public.arn
  }

  depends_on = [
    kubernetes_namespace.nginx,
  ]

  timeout = 1200

}
