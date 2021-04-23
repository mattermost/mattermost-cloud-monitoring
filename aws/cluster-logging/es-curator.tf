resource "helm_release" "es_curator" {
  name       = "mattermost-cm-es-curator"
  namespace  = "logging"
  repository = "https://charts.helm.sh/stable"
  chart      = "elasticsearch-curator"
  values = [
    file("../../../../chart-values/elasticsearch-curator_values.yaml")
  ]
}
