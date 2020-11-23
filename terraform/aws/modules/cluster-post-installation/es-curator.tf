resource "helm_release" "es_curator" {
  name       = "mattermost-cm-es-curator"
  namespace  = "logging"
  repository = data.helm_repository.stable.metadata.0.name
  chart      = "stable/elasticsearch-curator"
  values = [
    file("../../../../chart-values/elasticsearch-curator_values.yaml")
  ]
}
