resource "aws_iam_role" "cluster-autoscaler-role" {
  name               = "k8s-${var.environment}-cluster-autoscaler"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Federated": "${var.open_oidc_provider_arn}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${var.open_oidc_provider_url}:sub": "system:serviceaccount:${var.namespace}:${var.serviceaccount}"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_policy" "cluster-autoscaler-policy" {
  name        = "cluster-autoscaler-policy"
  path        = "/"
  description = "S3 & Volume permissions for cluster-autoscaler role"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "autoscaling:DescribeAutoScalingGroups",
              "autoscaling:DescribeAutoScalingInstances",
              "autoscaling:DescribeLaunchConfigurations",
              "autoscaling:DescribeTags",
              "autoscaling:SetDesiredCapacity",
              "autoscaling:TerminateInstanceInAutoScalingGroup",
              "ec2:DescribeLaunchTemplateVersions",
              "eks:DescribeNodegroup"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "cluster-autoscaler-policy-attach" {
  role       = aws_iam_role.cluster-autoscaler-role.name
  policy_arn = aws_iam_policy.cluster-autoscaler-policy.arn
}
