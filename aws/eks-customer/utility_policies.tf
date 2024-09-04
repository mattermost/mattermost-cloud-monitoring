resource "aws_iam_policy" "bifrost" {
  for_each = { for k, v in var.utilities : k => v if v.name == "bifrost" }

  name        = "bifrost-${var.cluster_name}"
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

  name        = "velero-${var.cluster_name}"
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
                "arn:aws:s3:::cloud-velero-dev/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::cloud-velero-dev"
            ]
        }
    ]
}
EOF
}
