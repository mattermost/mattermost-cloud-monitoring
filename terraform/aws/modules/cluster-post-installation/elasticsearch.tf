resource "helm_release" "elasticsearch" {
  name       = "mattermost-cm-elasticsearch"
  namespace  = "monitoring"
  repository = "${data.helm_repository.stable.metadata.0.name}"
  chart      = "stable/elasticsearch"
  values = [
    "${file("../../../../../chart-values/elasticsearch_values.yaml")}"
  ]
  depends_on = [
    "kubernetes_cluster_role_binding.tiller", 
    "kubernetes_service_account.tiller",
    "kubernetes_namespace.monitoring"
  ]
}
