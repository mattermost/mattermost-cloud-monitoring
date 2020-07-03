data "template_file" "kubeconfig" {
  template = "${file("${path.module}/templates/kubeconfig.tpl")}"

  vars = {
    cluster_name     = aws_eks_cluster.cluster.name
    cluster_endpoint = aws_eks_cluster.cluster.endpoint
    cluster_ca       = aws_eks_cluster.cluster.certificate_authority.0.data
  }
}

# mkdir "${var.kubeconfig_dir}"

resource "null_resource" "cluster_services" {
  provisioner "local-exec" {
    command = <<LOCAL_EXEC
      touch "${var.kubeconfig_dir}/kubeconfig"
      echo $KUBECONFIG_DATA > "${var.kubeconfig_dir}/kubeconfig"
    LOCAL_EXEC
    environment = {
      KUBECONFIG_DATA = "${data.template_file.kubeconfig.rendered}"
    }
  }
}
