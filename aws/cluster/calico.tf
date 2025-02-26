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

resource "null_resource" "patch_aws_node" {
  count = var.is_calico_enabled ? 1 : 0

  provisioner "local-exec" {
    command = <<EOF
KUBECONFIG=${path.root}/kubeconfig-${aws_eks_cluster.cluster.name} kubectl patch daemonset aws-node -n kube-system --type=json -p='[
  {
    "op": "replace",
    "path": "/spec/template/spec/affinity",
    "value": {
      "nodeAffinity": {
        "requiredDuringSchedulingIgnoredDuringExecution": {
          "nodeSelectorTerms": [
            {
              "matchExpressions": [
                {
                  "key": "kubernetes.io/os",
                  "operator": "In",
                  "values": ["linux"]
                },
                {
                  "key": "kubernetes.io/arch",
                  "operator": "In",
                  "values": ["amd64", "arm64"]
                },
                {
                  "key": "eks.amazonaws.com/compute-type",
                  "operator": "NotIn",
                  "values": ["fargate"]
                },
                {
                  "key": "calico",
                  "operator": "NotIn",
                  "values": ["true"]
                }
              ]
            }
          ]
        }
      }
    }
  }
]'
EOF
  }

}

