################» Worker Node IAM Role and Instance Profile#################
resource "aws_iam_role" "worker-role" {
  name = "${var.deployment_name}-worker-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "utilities_policy" {
  name        = "cloud-${var.cluster_short_name}-utilities-policy"
  path        = "/"
  description = "Policy for utilities required permissions."

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllS3Bucket",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:ListBucketVersions",
                "s3:CreateBucket"
            ],
            "Resource": [
                "arn:aws:s3:::cloud-${var.environment}-${var.cluster_short_name}",
                "arn:aws:s3:::cloud-${var.environment}-prometheus-metrics"

            ]
        },
        {
            "Sid": "AllS3Object",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::cloud-${var.environment}-${var.cluster_short_name}/*",
                "arn:aws:s3:::cloud-${var.environment}-prometheus-metrics/*"
            ]
        },
        {
            "Sid": "AllActionsOnTeleportDB",
            "Effect": "Allow",
            "Action": "dynamodb:*",
            "Resource": [
              "arn:aws:dynamodb:*:${data.aws_caller_identity.current.account_id}:table/cloud-${var.environment}-${var.cluster_short_name}*"
            ]
        },
        {
            "Sid": "Route53Access",
            "Effect": "Allow",
            "Action": "route53:ListResourceRecordSets",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "cluster_autoscaler_policy" {
  name        = "cloud-${var.cluster_short_name}-cluster-autoscaler-policy"
  path        = "/"
  description = "Policy for cluster autoscaler required permissions."

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeTags",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup",
                "ec2:DescribeLaunchTemplateVersions"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "cost_explorer_policy" {
  name        = "cloud-${var.cluster_short_name}-cost-explorer-policy"
  path        = "/"
  description = "Policy for cost explorer required permissions."

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "ce:*",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "worker_cost_explorer_policy" {
  policy_arn = aws_iam_policy.cost_explorer_policy.arn
  role       = aws_iam_role.worker-role.name
}

resource "aws_iam_role_policy_attachment" "worker_cluster_autoscaler_policy" {
  policy_arn = aws_iam_policy.cluster_autoscaler_policy.arn
  role       = aws_iam_role.worker-role.name
}

resource "aws_iam_role_policy_attachment" "worker_utilities_policy" {
  policy_arn = aws_iam_policy.utilities_policy.arn
  role       = aws_iam_role.worker-role.name
}

resource "aws_iam_role_policy_attachment" "worker-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.worker-role.name
}

resource "aws_iam_role_policy_attachment" "worker-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.worker-role.name
}

resource "aws_iam_role_policy_attachment" "worker-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.worker-role.name
}

resource "aws_iam_instance_profile" "worker-instance-profile" {
  name = "${var.deployment_name}-worker-instance-profile"
  role = aws_iam_role.worker-role.name
}

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.worker-role.name
}

resource "aws_iam_role_policy_attachment" "amazons_eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.worker-role.name
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_readonly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.worker-role.name
}

resource "aws_iam_policy" "kube2iam-eks-policy" {
  name        = "cloud-${var.cluster_short_name}-kube2iam-policy"
  description = "kube2iam policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sts:AssumeRole"
      ],
      "Effect": "Allow",
      "Resource": [ "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/k8s-*",
                     "${aws_iam_role.worker-role.arn}"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "kube2iam-policy-attach" {
  policy_arn = aws_iam_policy.kube2iam-eks-policy.arn
  role       = aws_iam_role.worker-role.name
}
