resource "null_resource" "delete_aws_node" {
	provisioner "local-exec" {
	  command = "KUBECONFIG=${path.module}/kubeconfig kubectl delete daemonset aws-node -n kube-system"
	}

	depends_on = [ module.eks, time_sleep.this, resource.local_file.kubeconfig ]
}

resource "null_resource" "install_calico_operator" {
	provisioner "local-exec" {
	  command = "KUBECONFIG=${path.module}/kubeconfig kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/${var.calico_operator_version}/manifests/tigera-operator.yaml"
	}

	depends_on = [ module.eks, time_sleep.this, resource.local_file.kubeconfig ]
}

resource "null_resource" "calico_operator_configuration" {
  provisioner "local-exec" {
    command = <<EOF
      KUBECONFIG=${path.module}/kubeconfig kubectl apply -f ${path.module}/calico_installation.yaml
    EOF
  }

  depends_on = [ null_resource.install_calico_operator ]
}