resource "helm_release" "fluent_bit" {
  name       = "mattermost-cm-fluent-bit"
  namespace  = "logging"
  repository = "https://fluent.github.io/helm-charts"
  chart      = "fluent-bit"
  version    = var.fluent_bit_chart_version
  values = [
    file("../../../../chart-values/fluent-bit_values.yaml")
  ]
}
