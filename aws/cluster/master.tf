resource "aws_eks_cluster" "cluster" {
  name     = var.deployment_name
  role_arn = aws_iam_role.cluster-role.arn

  vpc_config {
    security_group_ids      = [aws_security_group.cluster-sg.id]
    subnet_ids              = flatten([var.public_subnet_ids, var.private_subnet_ids])
    endpoint_private_access = true
    endpoint_public_access  = false
  }

  enabled_cluster_log_types = var.log_types

  depends_on = [
    aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster-AmazonEKSServicePolicy,
    aws_iam_role.cluster-role,
  ]
}

# Get EKS cluster certificate thumbprint
data "tls_certificate" "cluster_openid_issuer" {
  url = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.cluster.name
}

# Create the OIDC provider
resource "aws_iam_openid_connect_provider" "eks_cluster_openid_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster_openid_issuer.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

output "eks_cluster_name" {
  value = aws_eks_cluster.cluster.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}

output "eks_cluster_certificate_authority" {
  value = aws_eks_cluster.cluster.certificate_authority[0].data
}

output "eks_cluster_service_cidr" {
  value = data.aws_eks_cluster.cluster.kubernetes_network_config[0].service_ipv4_cidr
}

