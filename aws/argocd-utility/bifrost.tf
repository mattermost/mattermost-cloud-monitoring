
locals {
  s3_bucket = base64encode("mattermost-cloud-dev-provisioning-${var.vpc_id}")

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

resource "null_resource" "bifrost_config" {
  provisioner "local-exec" {
    command = <<EOF
      echo "${local.bifrost_secret}" | KUBECONFIG=${path.root}/kubeconfig kubectl apply -f -
EOF
  }
}
