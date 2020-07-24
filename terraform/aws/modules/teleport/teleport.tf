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
  depends_on = [
    kubernetes_namespace.teleport,
  ]
}


resource "kubernetes_namespace" "teleport" {
  metadata {
    name = "teleport"
  }
}
