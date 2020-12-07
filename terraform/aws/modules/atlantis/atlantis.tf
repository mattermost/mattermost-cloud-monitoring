resource "kubernetes_namespace" "atlantis" {
  metadata {
    name = "atlantis"
  }
}

resource "helm_release" "atlantis" {
  name      = "atlantis"
  chart     = "stable/atlantis"
  namespace = "atlantis"
  version   = var.atlantis_chart_version
  values = [
    file(var.atlantis_chart_values_directory)
  ]

  set {
    name  = "orgWhitelist"
    value = var.org_whitelist
  }

  set {
    name  = "gitlab.user"
    value = var.gitlab_user
  }

  set {
    name  = "gitlab.token"
    value = var.gitlab_token
  }

  set {
    name  = "gitlab.secret"
    value = var.gitlab_webhook_secret
  }

  set {
    name  = "gitlab.hostname"
    value = var.gitlab_hostname
  }

  set {
    name  = "ingress.host"
    value = var.atlantis_hostname
  }

  set {
    name  = "tls.hosts"
    value = var.atlantis_hostname
  }

  # the AWS credentials will be created manually and we will set here the secret name that was created
  set {
    name  = "awsSecretName"
    value = var.aws_secretname
  }

  set {
    name  = "defaultTFVersion"
    value = var.terraform_default_version
  }


  depends_on = [
    kubernetes_namespace.atlantis,
    helm_release.internal_nginx,
  ]

  timeout = 1200

}
