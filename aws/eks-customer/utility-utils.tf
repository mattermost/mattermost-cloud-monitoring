
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

resource "null_resource" "bifrost_config" {
  provisioner "local-exec" {
    command = <<EOF
      echo "${local.bifrost_secret}" | KUBECONFIG=${path.root}/kubeconfig-${module.eks.cluster_name} kubectl apply -f -
EOF
  }
  depends_on = [null_resource.deploy-utilites, aws_route53_record.internal]
}

resource "null_resource" "bifrost_annotate_sa" {
  provisioner "local-exec" {
    command = <<EOF
      KUBECONFIG=${path.root}/kubeconfig-${module.eks.cluster_name} kubectl -n bifrost annotate sa bifrost \
      eks.amazonaws.com/role-arn=arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/bifrost-${module.eks.cluster_name} \
      --overwrite=true
EOF
  }

  depends_on = [null_resource.deploy-utilites, aws_route53_record.internal]
}
