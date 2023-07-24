resource "aws_iam_user" "exports" {
  count = var.create_exports_user ? 1 : 0

  name = "mattermost-cloud-${var.environment}-exports"
  path = "/"
}

resource "aws_iam_policy" "exports" {
  count = var.create_exports_user ? 1 : 0

  name        = "mattermost-cloud-${var.environment}-exports-policy"
  description = "A policy attached to exports IAM user"
  path        = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:GetBucketTagging"
        ]
        Effect   = "Allow"
        Resource = "${var.exports_bucket_arn}"
      },
      {
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObject",
          "s3:GetObjectAcl",
          "s3:DeleteObject",
          "s3:GetObjectVersionAcl"
        ],
        Effect   = "Allow",
        Resource = "${var.exports_bucket_arn}/*"
      },
    ]
  })
}

resource "aws_iam_user_policy_attachment" "exports" {
  count = var.create_exports_user ? 1 : 0

  user       = aws_iam_user.exports[0].name
  policy_arn = aws_iam_policy.exports[0].arn
}
