resource "helm_release" "prometheus-client" {
  name       = "mattermost-cm-prometheus-client"
  namespace  = "monitoring"
  repository = data.helm_repository.stable.metadata.0.name
  chart      = "stable/prometheus"
  wait       = false
  values = [
    "${file("../../../../../chart-values/prometheus-client_values.yaml")}"
  ]
  depends_on = [
    kubernetes_namespace.monitoring
  ]
}
