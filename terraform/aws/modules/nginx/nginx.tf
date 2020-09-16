data "aws_acm_certificate" "public" {
  domain      = var.public_domain_certificate
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

data "aws_acm_certificate" "private" {
  domain      = var.private_domain_certificate
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}


resource "kubernetes_namespace" "nginx" {
  metadata {
    name = "nginx"
  }
}

resource "helm_release" "nginx" {
  name      = "nginx"
  chart     = "ingress-nginx/ingress-nginx"
  namespace = "nginx"
  values = [
    "${file("../../../../chart-values/nginx_values.yaml")}"
  ]

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-cert"
    value = data.aws_acm_certificate.public.arn
  }

  set {
    name  = "controller.service.internal.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-cert"
    value = data.aws_acm_certificate.private.arn
  }

  depends_on = [
    kubernetes_namespace.nginx,
  ]

  timeout = 1200

}
