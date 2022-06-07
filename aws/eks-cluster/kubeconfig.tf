resource "null_resource" "cluster_services" {
  provisioner "local-exec" {
    command = <<LOCAL_EXEC
      mkdir "${var.kubeconfig_dir}"
      touch "${var.kubeconfig_dir}/kubeconfig"
      echo $KUBECONFIG_DATA | base64 --decode > "${var.kubeconfig_dir}/kubeconfig"
    LOCAL_EXEC
    environment = {
      KUBECONFIG_DATA = base64encode(templatefile("${path.module}/templates/kubeconfig.tpl", {
        cluster_name     = aws_eks_cluster.cluster.name,
        cluster_endpoint = aws_eks_cluster.cluster.endpoint,
        cluster_ca       = aws_eks_cluster.cluster.certificate_authority.0.data
      }))
    }
  }
}
