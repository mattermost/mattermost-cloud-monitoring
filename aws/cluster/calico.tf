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

# Install Calico operator only if it is not already installed
resource "null_resource" "install_calico_operator" {
  count = var.is_calico_enabled ? 1 : 0

  provisioner "local-exec" {
    command = <<EOF
      if ! KUBECONFIG=${path.root}/kubeconfig-${aws_eks_cluster.cluster.name} \
      kubectl get deployment -n tigera-operator tigera-operator >/dev/null 2>&1; then
        echo "Installing Calico Operator..."
        KUBECONFIG=${path.root}/kubeconfig-${aws_eks_cluster.cluster.name} \
        kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/${var.calico_operator_version}/manifests/tigera-operator.yaml
        touch ${path.root}/calico_installed
      else
        echo "Calico Operator already installed. Skipping."
      fi
    EOF
  }

  depends_on = [aws_eks_cluster.cluster, resource.local_file.kubeconfig]
}

# 3. Apply Calico configuration if the operator was newly installed
resource "null_resource" "calico_operator_configuration" {
  count = var.is_calico_enabled ? 1 : 0

  provisioner "local-exec" {
    command = <<EOF
      if [ -f ${path.root}/calico_installed ]; then
        echo "Applying Calico configuration..."
        KUBECONFIG=${path.root}/kubeconfig-${aws_eks_cluster.cluster.name} kubectl apply -f ${path.module}/manifests
        touch ${path.root}/calico_config_applied
      else
        echo "Calico already configured. Skipping."
      fi
    EOF
  }

  depends_on = [null_resource.install_calico_operator]
}

resource "null_resource" "patch_calico_daemonset" {
  provisioner "local-exec" {
    command = <<EOF
kubectl patch daemonset calico-node -n calico-system --type='json' -p='[
  { "op": "add", "path": "/spec/template/spec/nodeSelector", "value": { "calico": "true" } },
  { "op": "add", "path": "/spec/template/spec/tolerations", "value": [
      { "key": "calico", "operator": "Exists", "effect": "NoSchedule" }
    ]
  }
]'
EOF
  }

  depends_on = [null_resource.calico_operator_configuration]
}

resource "null_resource" "patch_aws_node" {
  count = var.is_calico_enabled ? 1 : 0

  provisioner "local-exec" {
    command = <<EOF
      KUBECONFIG=${path.root}/kubeconfig-${aws_eks_cluster.cluster.name} kubectl patch daemonset aws-node -n kube-system --type='json' -p='[
  { "op": "add", "path": "/spec/template/spec/nodeSelector", "value": { "calico": "false" } }
]'
EOF
  }

  depends_on = [aws_eks_cluster.cluster]
}
