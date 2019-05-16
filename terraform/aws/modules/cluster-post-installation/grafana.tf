data "helm_repository" "stable" {
    name = "stable"
    url  = "https://kubernetes-charts.storage.googleapis.com"
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "grafana" {
  name       = "mattermost-cm-grafana"
  namespace  = "monitoring"
  repository = "${data.helm_repository.stable.metadata.0.name}"
  chart      = "stable/grafana"
  values = [
    "${file("../../../../../chart-values/grafana_values.yaml")}"
  ]
  depends_on = [
    "kubernetes_cluster_role_binding.tiller", 
    "kubernetes_service_account.tiller",
    "kubernetes_namespace.monitoring"
  ]
}
