resource "helm_release" "blackbox" {
  name       = "mattermost-cm-blackbox"
  namespace  = "monitoring"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus-blackbox-exporter"
  version    = var.blackbox_exporter_chart_version
  values = [
    file("../../../../chart-values/blackbox_values.yaml")
  ]
  depends_on = [
    kubernetes_namespace.monitoring
  ]
}
