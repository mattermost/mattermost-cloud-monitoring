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

resource "kubectl_manifest" "calico_operator_configuration" {
    yaml_body = <<EOF
kind: Installation
apiVersion: operator.tigera.io/v1
metadata:
  name: default
spec:
  kubernetesProvider: EKS
  cni:
    type: Calico
  calicoNetwork:
    bgp: Disabled
EOF
    
    depends_on = [ null_resource.install_calico_operator ]
}