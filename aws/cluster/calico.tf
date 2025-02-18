resource "local_file" "kubeconfig" {
  content  = local.kubeconfig
  filename = "${path.root}/kubeconfig-${aws_eks_cluster.cluster.name}"

}

resource "aws_secretsmanager_secret" "kubeconfig_secret" {
  name = aws_eks_cluster.cluster.name
}

resource "aws_secretsmanager_secret_version" "kubeconfig_secret_version" {
  secret_id     = aws_secretsmanager_secret.kubeconfig_secret.id
  secret_string = local_file.kubeconfig.content

  depends_on = [local.kubeconfig]
}

resource "null_resource" "delete_aws_node" {
  count = var.is_calico_enabled ? 1 : 0

  provisioner "local-exec" {
    command = "KUBECONFIG=${path.root}/kubeconfig-${aws_eks_cluster.cluster.name} kubectl delete daemonset aws-node -n kube-system"
  }

  depends_on = [resource.local_file.kubeconfig]
}

resource "null_resource" "install_calico_operator" {
  count = var.is_calico_enabled ? 1 : 0

  provisioner "local-exec" {
    command = "KUBECONFIG=${path.root}/kubeconfig-${aws_eks_cluster.cluster.name} kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/${var.calico_operator_version}/manifests/tigera-operator.yaml"
  }

  depends_on = [aws_eks_cluster.cluster, resource.local_file.kubeconfig]
}

resource "null_resource" "calico_operator_configuration" {
  count = var.is_calico_enabled ? 1 : 0

  provisioner "local-exec" {
    command = <<EOF
      KUBECONFIG=${path.root}/kubeconfig-${aws_eks_cluster.cluster.name} kubectl apply -f ${path.module}/manifests
    EOF
  }

  depends_on = [null_resource.install_calico_operator]
}

