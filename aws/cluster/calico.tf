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

# 1. Handle aws-node DaemonSet deletion gracefully
resource "null_resource" "delete_aws_node" {
  count = var.is_calico_enabled ? 1 : 0

  provisioner "local-exec" {
    command = <<EOF
      KUBECONFIG=${path.root}/kubeconfig-${aws_eks_cluster.cluster.name} \
      kubectl delete daemonset aws-node -n kube-system --ignore-not-found=true || true
    EOF
  }

  depends_on = [resource.local_file.kubeconfig]
}

# 2. Install Calico operator only if it is not already installed
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

# 4. Refresh nodes **ONLY IF** Calico was newly installed (1-by-1)
resource "null_resource" "refresh_eks_nodes" {
  count = var.is_calico_enabled ? 1 : 0

  provisioner "local-exec" {
    command = <<EOF
      if [ -f ${path.root}/calico_config_applied ]; then
        echo "Rolling out new nodes for Calico changes (1-by-1 refresh)..."

        ASG_NAME="${var.cluster_short_name}-arm-nodes"

        INSTANCE_IDS=$(aws autoscaling describe-auto-scaling-groups \
          --auto-scaling-group-names "$ASG_NAME" \
          --query "AutoScalingGroups[0].Instances[*].InstanceId" \
          --output text)

        for INSTANCE in $INSTANCE_IDS; do
          echo "Terminating instance: $INSTANCE"
          aws autoscaling terminate-instance-in-auto-scaling-group --instance-id "$INSTANCE" --should-decrement-desired-capacity false

          echo "Waiting for the new node to be ready..."
          sleep 180  # Wait 3 minutes for the node to join the cluster

          # Ensure the node is in a Ready state before proceeding
          while true; do
            NEW_NODES=$(KUBECONFIG=${path.root}/kubeconfig-${aws_eks_cluster.cluster.name} \
              kubectl get nodes --no-headers | grep -c " Ready ")
            if [ "$NEW_NODES" -gt 0 ]; then
              echo "New node is ready, proceeding to next."
              break
            fi
            echo "Waiting for the node to become Ready..."
            sleep 30
          done
        done

        echo "Node refresh complete."
      else
        echo "Skipping node refresh since Calico was already installed."
      fi
    EOF
  }

  depends_on = [null_resource.calico_operator_configuration]
}


