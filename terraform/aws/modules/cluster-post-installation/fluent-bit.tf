resource "helm_release" "fluent_bit" {
  name       = "mattermost-cm-fluent-bit"
  namespace  = "logging"
  repository = data.helm_repository.stable.metadata.0.name
  chart      = "stable/fluent-bit"
  values = [
    "${file("../../../../../../chart-values/fluent-bit_values.yaml")}"
  ]
}
