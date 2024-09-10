resource "null_resource" "delete_aws_node" {
  provisioner "local-exec" {
    command = "KUBECONFIG=${path.root}/kubeconfig-${var.cluster_name} kubectl delete daemonset aws-node -n kube-system"
  }

  depends_on = [module.eks, time_sleep.wait_for_cluster, resource.local_file.kubeconfig]
}

resource "null_resource" "install_calico_operator" {
  provisioner "local-exec" {
    command = "KUBECONFIG=${path.root}/kubeconfig-${var.cluster_name} kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/${var.calico_operator_version}/manifests/tigera-operator.yaml"
  }

  depends_on = [module.eks, time_sleep.wait_for_cluster, resource.local_file.kubeconfig]
}

resource "null_resource" "calico_operator_configuration" {
  provisioner "local-exec" {
    command = <<EOF
      KUBECONFIG=${path.root}/kubeconfig-${var.cluster_name} kubectl apply -f ${path.module}/calico_config
    EOF
  }

  depends_on = [null_resource.install_calico_operator]
}
