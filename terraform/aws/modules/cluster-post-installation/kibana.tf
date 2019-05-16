resource "helm_release" "kibana" {
  name       = "mattermost-cm-kibana"
  namespace  = "monitoring"
  repository = "${data.helm_repository.stable.metadata.0.name}"
  chart      = "stable/kibana"
  values = [
    "${file("../../../../../chart-values/kibana_values.yaml")}"
  ]
  depends_on = [
    "kubernetes_cluster_role_binding.tiller", 
    "kubernetes_service_account.tiller",
    "kubernetes_namespace.monitoring"  
    ]
}
