resource "helm_release" "grafana" {
  name       = "mattermost-cm-grafana"
  namespace  = "monitoring"
  chart      = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  version    = var.grafana_chart_version
  values = [
    file("../../../../chart-values/grafana_values.yaml")
  ]

  set {
    name  = "datasources.datasources\\.yaml.datasources[1].url"
    value = var.aws_db_instance_provisioner_endpoint
    type  = "string"
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
    kubernetes_config_map.mattermost_performance_monitoring_per_cluster,
    kubernetes_config_map.coredns,
    kubernetes_config_map.nginx_ingress_controller,
    kubernetes_config_map.skydns,
    kubernetes_config_map.uptime_view,
    kubernetes_config_map.aws_rds_metrics,
    kubernetes_config_map.bind_dns
  ]
}
