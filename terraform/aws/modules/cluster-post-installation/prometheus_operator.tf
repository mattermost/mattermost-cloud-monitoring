resource "helm_release" "prometheus_operator" {
  name       = "prometheus-operator"
  namespace  = "monitoring"
  repository = data.helm_repository.prometheus_community.metadata.0.name
  chart      = "prometheus-community/kube-prometheus-stack"
  version    = var.prometheus_operator_chart_version
  values = [
    "${file("../../../../chart-values/prometheus_operator_values.yaml")}"
  ]
  depends_on = [
    kubernetes_namespace.monitoring
  ]
}
