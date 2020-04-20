resource "helm_release" "kibana" {
  name       = "mattermost-cm-kibana"
  namespace  = "logging"
  repository = data.helm_repository.stable.metadata.0.name
  chart      = "stable/kibana"
  values = [
    "${file("../../../../../chart-values/kibana_values.yaml")}"
  ]
}
