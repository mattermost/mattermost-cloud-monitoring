data "aws_acm_certificate" "private" {
  domain      = var.private_domain_certificate
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}


resource "kubernetes_namespace" "nginx-internal" {
  metadata {
    name = "nginx-internal"
  }
}

resource "helm_release" "nginx-internal" {
  name       = "nginx-internal"
  chart      = "ingress-nginx"
  version    = var.nginx_chart_version
  repository = "https://kubernetes.github.io/ingress-nginx/"
  namespace  = "nginx-internal"
  values = [
    file("../../../../chart-values/nginx_internal_values.yaml")
  ]

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-cert"
    value = data.aws_acm_certificate.private.arn
  }

  depends_on = [
    kubernetes_namespace.nginx-internal,
  ]

  timeout = 1200

}
