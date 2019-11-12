resource "helm_release" "fluentd" {
  name       = "mattermost-cm-fluentd"
  namespace  = "logging"
  repository = data.helm_repository.stable.metadata.0.name
  chart      = "stable/fluentd-elasticsearch"
  values = [
    "${file("../../../../../../chart-values/fluentd-elasticsearch_values.yaml")}"
  ]
}
