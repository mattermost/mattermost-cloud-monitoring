resource "aws_eks_addon" "vpc_cni" {
  count = var.enable_vpc_cni_addon ? 1 : 0

  cluster_name = aws_eks_cluster.cluster.name
  addon_name   = "vpc-cni"
  addon_version = var.vpc_cni_addon_version

  depends_on = [
      aws_iam_role_policy_attachment.cluster-AmazonEKSCNIPolicy
  ]
}

resource "aws_eks_addon" "coredns" {
  count = var.enable_coredns_addon ? 1 : 0

  cluster_name = aws_eks_cluster.cluster.name
  addon_name   = "coredns"
  addon_version = var.coredns_addon_version
  resolve_conflicts = "OVERWRITE"
}


resource "aws_eks_addon" "kube_proxy" {
  count = var.enable_kube_proxy_addon ? 1 : 0

  cluster_name = aws_eks_cluster.cluster.name
  addon_name   = "kube-proxy"
  addon_version = var.kube_proxy_addon_version
  resolve_conflicts = "OVERWRITE"
}
