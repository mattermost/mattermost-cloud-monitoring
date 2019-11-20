resource "helm_release" "fluentd" {
  name       = "mattermost-cm-fluentd"
  namespace  = "logging"
  repository = data.helm_repository.kiwigrid.metadata.0.name
  chart      = "kiwigrid/fluentd-elasticsearch"
  values = [
    "${file("../../../../../../chart-values/fluentd-elasticsearch_values.yaml")}"
  ]
}
