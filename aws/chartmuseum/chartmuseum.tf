resource "kubernetes_namespace" "chartmuseum" {
  metadata {
    name = "chartmuseum"
  }
}

resource "helm_release" "chartmuseum" {
  name      = "chartmuseum"
  chart     = "stable/chartmuseum"
  namespace = "chartmuseum"
  values = [
    file(var.chartmuseum_chart_values_directory)
  ]

  set {
    name  = "env.open.STORAGE_AMAZON_BUCKET"
    value = var.chartmuseum_bucket
  }

  set {
    name  = "env.secret.AWS_ACCESS_KEY_ID"
    value = var.chartmuseum_user_key_id
  }

  set {
    name  = "env.secret.AWS_SECRET_ACCESS_KEY"
    value = var.chartmuseum_user_access_key
  }

  set {
    name  = "ingress.hosts[0].name"
    value = var.chartmuseum_hostname
  }


  depends_on = [
    kubernetes_namespace.chartmuseum,
  ]

  timeout = 1200

}
