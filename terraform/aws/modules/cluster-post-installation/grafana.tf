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
    value = var.aws_db_instance_provisioner_endpoint
  }
  depends_on = [
    kubernetes_namespace.monitoring,
    kubernetes_config_map.account_view,
    kubernetes_config_map.cluster_view,
    kubernetes_config_map.installation_view,
    kubernetes_config_map.alerting,
    kubernetes_config_map.account_monitoring,
    kubernetes_config_map.aws_rds_overview,
    kubernetes_config_map.go_metrics_per_namespace_installation,
    kubernetes_config_map.mattermost_performance_kpi_metrics_per_cluster,
    kubernetes_config_map.mattermost_performance_monitoring_per_cluster
  ]
}
