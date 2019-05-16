resource "kubernetes_namespace" "network" {
  metadata {
    name = "network"
  }
}

resource "helm_release" "nginx" {
  name       = "mattermost-cm-nginx"
  namespace  = "network"
  repository = "${data.helm_repository.stable.metadata.0.name}"
  chart      = "stable/nginx-ingress"
  depends_on = [
    "kubernetes_cluster_role_binding.tiller", 
    "kubernetes_service_account.tiller",
    "kubernetes_namespace.network"
  ]
}

