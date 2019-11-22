resource "helm_release" "grafana" {
  name       = "mattermost-cm-grafana"
  namespace  = "monitoring"
  repository = data.helm_repository.stable.metadata.0.name
  chart      = "stable/grafana"
  values = [
    "${file("../../../../../../chart-values/grafana_values.yaml")}"
  ]
  depends_on = [
    "kubernetes_namespace.monitoring"
  ]
}
