resource "aws_eks_addon" "kube_proxy" {
  cluster_name  = module.eks.cluster_name
  addon_name    = "kube-proxy"
  addon_version = var.kube_proxy_version

  depends_on = [module.eks, module.managed_node_group.node_group_status]
}

resource "aws_eks_addon" "coredns" {
  cluster_name  = module.eks.cluster_name
  addon_name    = "coredns"
  addon_version = var.coredns_version

  depends_on = [module.eks, module.managed_node_group.node_group_status]
}

resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name  = module.eks.cluster_name
  addon_name    = "aws-ebs-csi-driver"
  addon_version = var.ebs_csi_driver_version

  depends_on = [module.eks, module.managed_node_group.node_group_status]
}

resource "aws_eks_addon" "snapshot-controller" {
  cluster_name  = module.eks.cluster_name
  addon_name    = "snapshot-controller"
  addon_version = var.snapshot_controller_version

  depends_on = [module.eks, module.managed_node_group.node_group_status]
}

resource "aws_eks_addon" "efs_csi_driver" {
  cluster_name  = module.eks.cluster_name
  addon_name    = "aws-efs-csi-driver"
  addon_version = var.efs_csi_driver_version

  depends_on = [module.eks, module.managed_node_group.node_group_status]
}
