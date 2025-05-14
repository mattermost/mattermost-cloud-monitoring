resource "aws_iam_policy" "bifrost" {
  for_each = { for k, v in var.utilities : k => v if v.name == "bifrost" }

  name        = "bifrost-${module.eks.cluster_name}"
  path        = "/"
  description = "Policy for bifrost utility."

  policy = <<EOF
{
    "Statement": [
        {
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:s3:::mattermost-cloud-${var.environment}-provisioning-${var.vpc_id}",
            "Sid": "ListObjectsInBucket"
        },
        {
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:ListBucket",
                "s3:PutObjectAcl",
                "s3:DeleteObject"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:s3:::mattermost-cloud-${var.environment}-provisioning-${var.vpc_id}/*",
            "Sid": "AllObjectActions"
        }
    ],
    "Version": "2012-10-17"
}
EOF
}

resource "aws_iam_policy" "velero" {
  for_each = { for k, v in var.utilities : k => v if v.name == "velero" }

  name        = "velero-${module.eks.cluster_name}"
  path        = "/"
  description = "Policy for velero utility."

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeVolumes",
                "ec2:DescribeSnapshots",
                "ec2:CreateTags",
                "ec2:CreateVolume",
                "ec2:CreateSnapshot",
                "ec2:DeleteSnapshot"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:PutObject",
                "s3:AbortMultipartUpload",
                "s3:ListMultipartUploadParts"
            ],
            "Resource": [
                "arn:aws:s3:::cloud-velero-${var.environment}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::cloud-velero-${var.environment}"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_policy" "external-secrets" {
  for_each = { for k, v in var.utilities : k => v if v.name == "external-secrets" }

  name        = "external-secrets-${module.eks.cluster_name}"
  path        = "/"
  description = "Policy for external-secrets utility."

  policy = <<EOF
{
    "Statement": [
        {
            "Action": [
                "secretsmanager:GetSecretValue",
                "secretsmanager:DescribeSecret",
                "secretsmanager:GetResourcePolicy",
                "secretsmanager:ListSecretVersionIds"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:secretsmanager:us-east-1:${data.aws_caller_identity.current.account_id}:secret:app-bifrost-*",
                "arn:aws:secretsmanager:us-east-1:${data.aws_caller_identity.current.account_id}:secret:app-external-dns-public-*",
                "arn:aws:secretsmanager:us-east-1:${data.aws_caller_identity.current.account_id}:secret:app-wiz-kubernetes-connector-*"
            ]
        }
    ],
    "Version": "2012-10-17"
}
EOF
}

resource "aws_iam_policy" "cluster-autoscaler" {
  for_each = { for k, v in var.utilities : k => v if v.name == "cluster-autoscaler" }

  name        = "cluster-autoscaler-${module.eks.cluster_name}"
  path        = "/"
  description = "Policy for cluster-autoscaler utility."

  policy = <<EOF
{
    "Statement": [
        {
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
            "Effect": "Allow",
            "Resource": "*"
        }
    ],
    "Version": "2012-10-17"
}
EOF
}

resource "aws_iam_policy" "external-dns-internal" {
  for_each = { for k, v in var.utilities : k => v if v.name == "external-dns-internal" }

  name        = "external-dns-internal-${module.eks.cluster_name}"
  path        = "/"
  description = "Policy for external-dns-internal utility."

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "route53:ChangeResourceRecordSets"
            ],
            "Resource": [
                "arn:aws:route53:::hostedzone/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "route53:ListHostedZones",
                "route53:ListResourceRecordSets"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}
