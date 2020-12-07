resource "helm_release" "fluent_bit" {
  name       = "mattermost-cm-fluent-bit"
  namespace  = "logging"
  repository = "https://charts.helm.sh/stable"
  chart      = "fluent-bit"
  values = [
    file("../../../../chart-values/fluent-bit_values.yaml")
  ]
}
