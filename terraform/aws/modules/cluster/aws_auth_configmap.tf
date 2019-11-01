resource "kubernetes_config_map" "aws_auth_configmap" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  data = {
      mapRoles = <<YAML
  - rolearn: "arn:aws:iam::${var.account_id}:role/${var.deployment_name}-worker-role"
    username: system:node:{{EC2PrivateDNSName}}
    groups:
      - system:bootstrappers
      - system:nodes
  - rolearn: "${aws_iam_role.lambda_role.arn}"
    username: admin
    groups:
      - system:masters
  YAML
  }
  depends_on = [
    "aws_eks_cluster.cluster",
    "null_resource.cluster_services",
    "aws_autoscaling_group.worker-asg",
    "aws_iam_role.lambda_role"
  ]
}
