resource "helm_release" "thanos" {
  name       = "mattermost-cm-thanos"
  namespace  = "monitoring"
  repository = data.helm_repository.bitnami.metadata.0.name
  chart      = "bitnami/thanos"
  values = [
    "${file("../../../../chart-values/thanos.yaml")}"
  ]
  depends_on = [
    kubernetes_namespace.monitoring
  ]
}
