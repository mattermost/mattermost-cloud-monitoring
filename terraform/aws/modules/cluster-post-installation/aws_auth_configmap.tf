data "aws_eks_cluster_auth" "cluster_auth" {
  name = "${var.deployment_name}"
}

data "aws_eks_cluster" "cluster" {
  name = "${var.deployment_name}"
}

resource "kubernetes_config_map" "aws_auth_configmap" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  data {
      mapRoles = <<YAML
  - rolearn: "arn:aws:iam::${var.account_id}:role/mattermost-central-monitoring-cluster-worker-role"
    username: system:node:{{EC2PrivateDNSName}}
    groups:
      - system:bootstrappers
      - system:nodes
  YAML
  }
}
