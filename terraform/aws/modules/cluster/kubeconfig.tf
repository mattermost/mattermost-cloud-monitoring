data "template_file" "kubeconfig" {
  template = file("${path.module}/templates/kubeconfig.tpl")

  vars = {
    cluster_name     = aws_eks_cluster.cluster.name
    cluster_endpoint = aws_eks_cluster.cluster.endpoint
    cluster_ca       = aws_eks_cluster.cluster.certificate_authority.0.data
  }
}
