data "aws_eks_cluster_auth" "cluster_auth" {
  name = "${var.deployment_name}"
  depends_on = [
    "aws_eks_cluster.cluster"
  ]
}

data "aws_eks_cluster" "cluster" {
  name = "${var.deployment_name}"
  depends_on = [
    "aws_eks_cluster.cluster"
  ]
}


provider "kubernetes" {
  host                   = "${data.aws_eks_cluster.cluster.endpoint}"
  cluster_ca_certificate = "${base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)}"
  token                  = "${data.aws_eks_cluster_auth.cluster_auth.token}"
  load_config_file       = false
}

resource "kubernetes_config_map" "aws_auth_configmap" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
data {
    mapRoles = <<YAML
- rolearn: "${aws_iam_role.worker-role.arn}"
  username: system:node:{{EC2PrivateDNSName}}
  groups:
    - system:bootstrappers
    - system:nodes
YAML
  }
  depends_on = [
    "aws_eks_cluster.cluster"
  ]
}
