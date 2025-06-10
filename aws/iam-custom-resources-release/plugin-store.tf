resource "aws_iam_role" "plugin_store_role" {
  name = "mattermost-release-${var.environment}-plugin-store-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = var.github_runners_iam_role_arn
        }
        Action = [
          "sts:TagSession",
          "sts:AssumeRole"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "plugin_store" {

  name        = "mattermost-release-${var.environment}-plugin-store-policy"
  description = "A policy attached to plugin store IAM role"
  path        = "/"
  policy      = <<EOF
{
    "Statement": [
        {
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::mattermost-plugins-delivery"
            ]
        },
        {
            "Action": [
                "s3:GetObject",
                "s3:GetObjectAcl",
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:AbortMultipartUpload",
                "s3:ListMultipartUploadParts",
                "s3:CreateMultipartUpload",
                "s3:CompleteMultipartUpload",
                "s3:ListBucketMultipartUploads"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::mattermost-plugins-delivery/*"
            ]
        }
    ],
    "Version": "2012-10-17"
}
EOF
}

resource "aws_iam_role_policy_attachment" "plugin_store_role" {
  policy_arn = aws_iam_policy.plugin_store.arn
  role       = aws_iam_role.plugin_store_role.name
}
