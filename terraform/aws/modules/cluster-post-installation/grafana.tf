resource "helm_release" "grafana" {
  name       = "mattermost-cm-grafana"
  namespace  = "monitoring"
  repository = data.helm_repository.stable.metadata.0.name
  chart      = "stable/grafana"
  values = [
    "${file("../../../../chart-values/grafana_values.yaml")}"
  ]
  set_string {
    name  = "datasources.datasources\\.yaml.datasources[1].url"
    value = aws_db_instance.provisioner.endpoint
  }
  depends_on = [
    kubernetes_namespace.monitoring,
    kubernetes_config_map.account_view,
    kubernetes_config_map.cluster_view,
    kubernetes_config_map.installation_view,
    kubernetes_config_map.alerting
  ]
}
