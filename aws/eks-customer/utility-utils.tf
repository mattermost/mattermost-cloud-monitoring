
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

resource "null_resource" "wait_for_thanos_query_grpc_lb" {
  provisioner "local-exec" {
    command = <<EOT
      KUBECONFIG=${path.root}/kubeconfig-${module.eks.cluster_name} bash ${path.module}/scripts/wait_for_lb.sh
    EOT
    environment = {
      NAMESPACE                  = "prometheus"
      SERVICE_NAME               = "thanos-query-grpc"
      TIMEOUT                    = 600
      INTERVAL                   = 5
    }
  }

  depends_on = [null_resource.deploy-utilites]
}

resource "null_resource" "wait_for_nginx_internal_lb" {
  provisioner "local-exec" {
    command = <<EOT
      KUBECONFIG=${path.root}/kubeconfig-${module.eks.cluster_name} bash ${path.module}/scripts/wait_for_lb.sh
    EOT
    environment = {
      NAMESPACE                  = "nginx-internal"
      SERVICE_NAME               = "nginx-internal-ingress-nginx-controller"
      TIMEOUT                    = 600
      INTERVAL                   = 5
    }
  }

  depends_on = [null_resource.deploy-utilites]
}