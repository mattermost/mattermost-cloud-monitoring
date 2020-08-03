resource "helm_release" "teleport" {
  name       = "teleport"
  namespace  = "teleport"
  repository = data.helm_repository.chartmuseum.metadata.0.name
  chart      = "chartmuseum/teleport"
  version    = var.teleport_chart_version

  set_string {
    name  = "config.auth_service.cluster_name"
    value = "cloud-${var.environment}-${var.cluster_name}"
  }
  set_string {
    name  = "config.teleport.storage.region"
    value = data.aws_region.current.name
  }
  set_string {
    name  = "config.teleport.storage.table_name"
    value = "cloud-${var.environment}-${var.cluster_name}"
  }
  set_string {
    name  = "config.teleport.storage.audit_events_uri"
    value = "dynamodb://cloud-${var.environment}-${var.cluster_name}-events"
  }
  set_string {
    name  = "config.teleport.storage.audit_sessions_uri"
    value = "s3://cloud-${var.environment}-${var.cluster_name}/records?region=${data.aws_region.current.name}"
  }
  depends_on = [
    kubernetes_namespace.teleport,
  ]
}


resource "kubernetes_namespace" "teleport" {
  metadata {
    name = "teleport"
  }
}
