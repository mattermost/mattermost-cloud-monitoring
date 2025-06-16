resource "aws_iam_role" "pulumi-github-sync-role" {
  count = var.create_pulumi_github_sync_role ? 1 : 0

  name = "mattermost-${var.environment}-pulumi-github-sync-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
        }
        Action = [
          "sts:AssumeRoleWithWebIdentity"
        ]
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" : var.github_repos_sub
          }
          StringEquals = {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "pulumi-github-sync-policy" {
  count = var.create_pulumi_github_sync_role ? 1 : 0

  name        = "mattermost-${var.environment}-pulumi-github-sync-policy"
  description = "A policy attached to pulumi-github-sync IAM role"
  path        = "/"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObjectAcl",
                "s3:GetObject",
                "s3:AbortMultipartUpload",
                "s3:ListBucket",
                "s3:PutObjectAcl",
                "s3:ListMultipartUploadParts",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::pulumi-github-mattermost-state",
                "arn:aws:s3:::pulumi-github-mattermost-state/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "pulumi-github-sync-role" {
  count = var.create_pulumi_github_sync_role ? 1 : 0

  policy_arn = aws_iam_policy.pulumi-github-sync-policy[0].arn
  role       = aws_iam_role.pulumi-github-sync-role[0].name
}
