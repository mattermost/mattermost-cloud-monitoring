resource "helm_release" "elasticsearch" {
  name       = "mattermost-cm-elasticsearch"
  namespace  = "logging"
  repository = "${data.helm_repository.stable.metadata.0.name}"
  chart      = "stable/elasticsearch"
  timeout    = 600
  values = [
    "${file("../../../../../chart-values/elasticsearch_values.yaml")}"
  ]
}
