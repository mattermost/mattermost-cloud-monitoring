
locals {
  data = var.matterwick_cluster_access_enabled == true ? {
    mapRoles = <<YAML
  - rolearn: "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.deployment_name}-worker-role"
    username: system:node:{{EC2PrivateDNSName}}
    groups:
      - system:bootstrappers
      - system:nodes
  - rolearn: "${aws_iam_role.dev_access_role.arn}"
    username: admin
    groups:
      - system:masters
  - rolearn: "${data.aws_region.current.name == "us-east-1" ? aws_iam_role.lambda_role[0].arn : data.aws_iam_role.lambda_role[0].arn}"
    username: admin
    groups:
      - system:masters
  YAML
    mapUsers = <<YAML
  - userarn: "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${var.matterwick_iam_user}"
    username: "${var.matterwick_username}"
  YAML
    } : {
    mapRoles = <<YAML
  - rolearn: "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.deployment_name}-worker-role"
    username: system:node:{{EC2PrivateDNSName}}
    groups:
      - system:bootstrappers
      - system:nodes
  - rolearn: "${aws_iam_role.dev_access_role.arn}"
    username: admin
    groups:
      - system:masters
  - rolearn: "${data.aws_region.current.name == "us-east-1" ? aws_iam_role.lambda_role[0].arn : data.aws_iam_role.lambda_role[0].arn}"
    username: admin
    groups:
      - system:masters${local.extra_auth_config_provider}
  YAML
  }
}

resource "time_sleep" "wait_120_seconds" {
  depends_on = [
    aws_eks_cluster.cluster,
    null_resource.cluster_services,
    aws_autoscaling_group.worker-asg,
    aws_iam_role.lambda_role
  ]
  create_duration = "120s"
}


resource "kubernetes_config_map" "aws_auth_configmap" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  data = local.data
  depends_on = [time_sleep.wait_120_seconds]
}


data "aws_iam_role" "lambda_role" {
  count = data.aws_region.current.name != "us-east-1" ? 1 : 0
  name  = "iam_for_lambda"
}

# Policies of that role will be created/attached on `prometheus-registration-service` module
resource "aws_iam_role" "lambda_role" {
  count = data.aws_region.current.name == "us-east-1" ? 1 : 0
  name  = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
