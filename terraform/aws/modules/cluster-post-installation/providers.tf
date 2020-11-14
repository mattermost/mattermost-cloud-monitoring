data "aws_caller_identity" "current" {}

# The data resources "helm_repository" are deprecated and should be removed after the migration
# to the official helm charts, check: terraform/aws/modules/cluster-post-installation/grafana.tf#L4
data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
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

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
  load_config_file       = false
  config_path            = "${var.kubeconfig_dir}/kubeconfig"
}

provider "helm" {
  install_tiller  = true
  service_account = "terraform-tiller"
  namespace       = "kube-system"
  tiller_image    = "gcr.io/kubernetes-helm/tiller:v${var.tiller_version}"
  kubernetes {
    config_path            = "${var.kubeconfig_dir}/kubeconfig"
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster_auth.token
    load_config_file       = false
  }
}
