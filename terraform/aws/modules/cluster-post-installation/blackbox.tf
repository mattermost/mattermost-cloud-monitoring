resource "helm_release" "blackbox" {
  name       = "mattermost-cm-blackbox"
  namespace  = "monitoring"
  repository = "https://charts.helm.sh/stable"
  chart      = "prometheus-blackbox-exporter"
  values = [
    file("../../../../chart-values/blackbox_values.yaml")
  ]
}
