resource "helm_release" "prometheus" {
  name       = "mattermost-cm-prometheus"
  namespace  = "monitoring"
  repository = "${data.helm_repository.stable.metadata.0.name}"
  chart      = "stable/prometheus"
  values = [
    "${file("../../../../../chart-values/prometheus_values.yaml")}"
  ]
  depends_on = [
    "kubernetes_cluster_role_binding.tiller", 
    "kubernetes_service_account.tiller",
    "kubernetes_namespace.monitoring"
  ]
}
