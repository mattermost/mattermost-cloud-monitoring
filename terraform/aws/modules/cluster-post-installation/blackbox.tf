resource "helm_release" "blackbox" {
  name       = "mattermost-cm-blackbox"
  namespace  = "monitoring"
  repository = data.helm_repository.stable.metadata.0.name
  chart      = "stable/prometheus-blackbox-exporter"
  values = [
    "${file("../../../../../chart-values/blackbox_values.yaml")}"
  ]
}
