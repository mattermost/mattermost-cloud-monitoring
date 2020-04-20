resource "helm_release" "nginx-internal" {
  name       = "mattermost-cm-nginx-internal"
  namespace  = "network"
  repository = data.helm_repository.stable.metadata.0.name
  chart      = "stable/nginx-ingress"
  values = [
    "${file("../../../../../chart-values/nginx-internal_values.yaml")}"
  ]
  depends_on = [
    kubernetes_namespace.network
  ]
  set_string {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-cert"
    value = aws_acm_certificate.wildcard_cert.arn
  }
}
