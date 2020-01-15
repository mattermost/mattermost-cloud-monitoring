################» EKS Master Cluster########################

provider "aws" {
  alias  = "deployment"
}

resource "aws_eks_cluster" "cluster" {
  name            = var.deployment_name
  role_arn        = aws_iam_role.cluster-role.arn

  vpc_config {
    security_group_ids = [aws_security_group.cluster-sg.id]
    subnet_ids         = flatten([var.public_subnet_ids, var.private_subnet_ids])
    endpoint_private_access = true
    endpoint_public_access = false
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster-AmazonEKSServicePolicy,
    aws_iam_role.cluster-role,
  ]
}
