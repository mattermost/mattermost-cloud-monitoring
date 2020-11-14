resource "helm_release" "thanos" {
  name       = "thanos"
  namespace  = "monitoring"
  repository = data.helm_repository.bitnami.metadata.0.name
  chart      = "bitnami/thanos"
  version    = var.thanos_chart_version
  values = [
    "${file("../../../../chart-values/thanos.yaml")}"
  ]
  depends_on = [
    kubernetes_namespace.monitoring,
    kubernetes_config_map.ruler_configmap
  ]
}


resource "kubernetes_config_map" "ruler_configmap" {
  metadata {
    name      = "thanos-ruler-configmap"
    namespace = "monitoring"
  }

  data = {
    "ruler.yml" = "${file("../../../../thanos-rules/rules.yaml")}"
  }

  depends_on = [
    kubernetes_namespace.monitoring
  ]
}
