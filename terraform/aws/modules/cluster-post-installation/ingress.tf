resource "helm_release" "nginx" {
  name       = "mattermost-cm-nginx"
  namespace  = "network"
  repository = "${data.helm_repository.stable.metadata.0.name}"
  chart      = "stable/nginx-ingress"
  depends_on = [
    "kubernetes_namespace.network"
  ]
}

