resource "helm_release" "oauth2-proxy" {
  name       = "mattermost-cm-oauth2"
  namespace  = "oauth2"
  repository = "${data.helm_repository.stable.metadata.0.name}"
  chart      = "stable/oauth2-proxy"
  values = [
    "${file("../../../../../../chart-values/oauth2-proxy_values.yaml")}"
  ]
}
