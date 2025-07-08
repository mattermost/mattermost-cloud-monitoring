terraform {
  required_version = ">= 1.6.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.100.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 2.2"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.2"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.5.1"
    }
  }
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = var.deployment_name
  depends_on = [
    aws_eks_cluster.cluster
  ]
}

provider "kubernetes" {
  host                   = aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
}
