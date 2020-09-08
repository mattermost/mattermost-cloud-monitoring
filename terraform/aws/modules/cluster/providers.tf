data "aws_eks_cluster_auth" "cluster_auth" {
  name = var.deployment_name
}

provider "kubernetes" {
  host                   = aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
  load_config_file       = false
  # config_path            = "${var.kubeconfig_dir}/kubeconfig"
  depends_on = [
    aws_eks_cluster.cluster,
    aws_autoscaling_group.worker-asg,
    aws_iam_role.lambda_role
  ]
}
