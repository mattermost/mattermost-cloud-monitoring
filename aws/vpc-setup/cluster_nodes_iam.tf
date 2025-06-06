data "aws_region" "current" {}

locals {
  conditional_dash_region       = data.aws_region.current.name == "us-east-1" ? "" : "-${data.aws_region.current.name}"
  region_splitted               = split("-", data.aws_region.current.name)
  region_subpart_2              = substr(local.region_splitted[1], 0, 1)
  region_part_3                 = regex("[[:digit:]]", data.aws_region.current.name)
  region_part_1                 = join("", [local.region_splitted[0], local.region_subpart_2])
  region_short                  = join("-", [local.region_part_1, local.region_part_3])
  conditional_dash_region_short = data.aws_region.current.name == "us-east-1" ? "" : "-${local.region_short}"
}

resource "aws_iam_policy" "node_policy" {
  count       = var.deploy_node_policy ? 1 : 0
  name        = "cloud-provisioning-node-policy${local.conditional_dash_region}"
  path        = "/"
  description = "Provisioning custom node policy"

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
                "arn:aws:s3:::cloud-${var.environment}-*"
            ]
        },
        {
            "Sid": "AllS3Object",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:DeleteObject*"
            ],
            "Resource": [
                "arn:aws:s3:::cloud-${var.environment}-*/*"
            ]
        },
        {
            "Action": [
                "autoscaling:DescribeAutoScalingInstances",
                "elasticloadbalancing:ModifyTargetGroup",
                "elasticloadbalancing:ModifyListener",
                "ec2:AuthorizeSecurityGroupIngress",
                "elasticfilesystem:DescribeMountTargets"
            ],
            "Effect": "Allow",
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_policy" "velero_node_policy" {
  count       = var.deploy_node_policy ? 1 : 0
  name        = "cloud-provisioning-node-policy-velero${local.conditional_dash_region}"
  path        = "/"
  description = "Provisioning custom node policy"

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
                "s3:ListBucket",
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
