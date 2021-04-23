resource "helm_release" "thanos" {
  name       = "thanos"
  namespace  = "monitoring"
  chart      = "thanos"
  version    = var.thanos_chart_version
  repository = "https://charts.bitnami.com/bitnami/"
  values = [
    file("../../../../chart-values/thanos.yaml")
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
    "ruler.yml" = file("../../../../thanos-rules/rules.yaml")
  }

  depends_on = [
    kubernetes_namespace.monitoring
  ]
}
