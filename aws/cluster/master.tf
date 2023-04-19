################» EKS Master Cluster########################
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

  tags = {
    VpcID = var.vpc_id
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster-AmazonEKSServicePolicy,
    aws_iam_role.cluster-role,
  ]
}

# Get EKS cluster certificate thumbprint
data "tls_certificate" "cluster-openid-issuer" {
  url = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

# Create the OIDC provider
resource "aws_iam_openid_connect_provider" "eks_cluster_openid_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster-openid-issuer.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}
