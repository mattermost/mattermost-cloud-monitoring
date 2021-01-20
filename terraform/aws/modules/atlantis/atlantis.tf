resource "kubernetes_namespace" "atlantis" {
  metadata {
    name = "atlantis"
  }
}

resource "helm_release" "atlantis" {
  name       = "atlantis"
  chart      = "atlantis"
  repository = "https://runatlantis.github.io/helm-charts"
  namespace  = "atlantis"
  version    = var.atlantis_chart_version
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

resource "aws_instance" "atlantis" {
  ami                          = var.ami_id
  availability_zone            = var.availability_zone
  instance_type                = var.instance_type
  key_name                     = var.key_name
  subnet_id                    = var.subnet_id
  disable_api_termination      = true

  credit_specification {
    cpu_credits = "unlimited"
  }

  tags = var.atlantis_instance_tags
}
