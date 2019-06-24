resource "helm_release" "kibana" {
  name       = "mattermost-cm-kibana"
  namespace  = "logging"
  repository = "${data.helm_repository.stable.metadata.0.name}"
  chart      = "stable/fluentd-elasticsearch"
  values = [
    "${file("../../../../../chart-values/fluentd-elasticsearch_values.yaml")}"
  ]
}
