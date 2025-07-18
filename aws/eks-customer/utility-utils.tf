
locals {
  s3_bucket = base64encode("mattermost-cloud-${var.environment}-provisioning-${var.vpc_id}")

  bifrost_secret = <<EOF
apiVersion: v1
data:
  Bucket: ${local.s3_bucket}
kind: Secret
metadata:
  name: bifrost
  namespace: bifrost
type: Opaque
EOF
}

resource "time_sleep" "wait_for_utilities" {

  create_duration = var.wait_for_utilities_timeout

  depends_on = [null_resource.deploy-utilites, module.eks, module.managed_node_group.node_group_status]
}

resource "null_resource" "bifrost_config" {
  provisioner "local-exec" {
    command = <<EOF
      echo "${local.bifrost_secret}" | KUBECONFIG=${path.root}/kubeconfig-${module.eks.cluster_name} kubectl apply -f -
EOF
  }
  depends_on = [time_sleep.wait_for_utilities]
}

resource "null_resource" "bifrost_annotate_sa" {
  provisioner "local-exec" {
    command = <<EOF
      KUBECONFIG=${path.root}/kubeconfig-${module.eks.cluster_name} kubectl -n bifrost annotate sa bifrost \
      eks.amazonaws.com/role-arn=arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/bifrost-${module.eks.cluster_name} \
      --overwrite=true
EOF
  }

  depends_on = [time_sleep.wait_for_utilities]
}

resource "null_resource" "pgbouncer_initial_setup" {
  provisioner "local-exec" {
    command = <<EOF
      KUBECONFIG=${path.root}/kubeconfig-${module.eks.cluster_name} kubectl apply -f ${path.module}/scripts/pgbouncer-initial-setup.yaml
EOF
  }
  depends_on = [time_sleep.wait_for_utilities]
}
