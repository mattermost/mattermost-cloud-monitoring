data "aws_caller_identity" "current" {}


resource "aws_iam_role" "velero-role" {
  name               = "k8s-${var.environment}-velero"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
         "AWS": [ "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.deployment_name}-worker-role" ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "velero-policy" {
  name        = "velero-policy"
  path        = "/"
  description = "S3 & Volume permissions for velero role"

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

resource "aws_iam_role_policy_attachment" "velero-policy-attach" {
  role       = aws_iam_role.velero-role.name
  policy_arn = aws_iam_policy.velero-policy.arn
}
