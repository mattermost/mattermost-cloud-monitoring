resource "aws_iam_user" "db_disaster_recovery" {
  count = var.create_db_disaster_user ? 1 : 0

  name = "mattermost-cloud-${var.environment}-db-disaster-recovery"
  path = "/"
}

resource "aws_iam_policy" "db_disaster_recovery" {
  count = var.create_db_disaster_user ? 1 : 0
  
  name        = "mattermost-cloud-${var.environment}-db-disaster-recovery-policy"
  description = "A policy attached to DB Disaster Recovery IAM user"
  path        = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "rds:*",
          "kms:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_user_policy_attachment" "db_disaster_recovery" {
  count = var.create_db_disaster_user ? 1 : 0

  user       = aws_iam_user.db_disaster_recovery[0].name
  policy_arn = aws_iam_policy.db_disaster_recovery[0].arn
}

