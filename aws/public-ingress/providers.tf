terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0.0"
    }
  }
}

data "helm_repository" "stable" {
  name = "stable"
  url  = "https://charts.helm.sh/stable"
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
  kubernetes {
    config_path            = "${var.kubeconfig_dir}/kubeconfig"
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster_auth.token
    load_config_file       = false
  }
}
