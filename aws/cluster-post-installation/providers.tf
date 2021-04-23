data "aws_caller_identity" "current" {}

data "helm_repository" "stable" {
  name = "stable"
  url  = "https://charts.helm.sh/stable"
}

data "helm_repository" "kiwigrid" {
  name = "kiwigrid"
  url  = "https://kiwigrid.github.io"
}

data "helm_repository" "prometheus_community" {
  name = "prometheus-community"
  url  = "https://prometheus-community.github.io/helm-charts"
}

data "helm_repository" "bitnami" {
  name = "bitnami"
  url  = "https://charts.bitnami.com/bitnami"
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = var.deployment_name
}

data "aws_eks_cluster" "cluster" {
  name = var.deployment_name
}
