terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws",
      version = "~> 4.0",
      configuration_aliases = [aws.deployment]
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.0.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "~> 2.0.0"
    }
  }
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = var.deployment_name
  depends_on = [
    aws_eks_cluster.cluster,
    aws_iam_role.lambda_role
  ]
}

provider "kubernetes" {
  host                   = aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
}
