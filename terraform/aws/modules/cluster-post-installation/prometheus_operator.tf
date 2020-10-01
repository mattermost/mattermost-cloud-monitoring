resource "helm_release" "prometheus_operator" {
  name       = "mattermost-cm-prometheus-operator"
  namespace  = "monitoring"
  repository = data.helm_repository.prometheus_community.metadata.0.name
  chart      = "prometheus-community/kube-prometheus-stack"
  values = [
    "${file("../../../../chart-values/prometheus_operator_values.yaml")}"
  ]
  depends_on = [
    kubernetes_namespace.monitoring
  ]
}
