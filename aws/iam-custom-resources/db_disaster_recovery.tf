resource "aws_iam_role" "db_disaster_recovery" {
  count = var.create_db_disaster_role ? 1 : 0

  name = "mattermost-cloud-${var.environment}-db-disaster-recovery"
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

resource "aws_iam_policy" "db_disaster_recovery" {
  count = var.create_db_disaster_role ? 1 : 0

  name        = "mattermost-cloud-${var.environment}-db-disaster-recovery-policy"
  description = "A policy attached to DB Disaster Recovery IAM role"
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
      {
        Action = [
          "secretsmanager:GetSecretValue"
        ],
        Effect   = "Allow",
        Resource = local.secret_manager_rds
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "db_disaster_recovery" {
  count = var.create_db_disaster_role ? 1 : 0

  role       = aws_iam_role.db_disaster_recovery[0].name
  policy_arn = aws_iam_policy.db_disaster_recovery[0].arn
}
