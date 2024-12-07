resource "aws_iam_role" "github_secrets_role" {
  name               = "GitHubSecretsAccessRole"
  assume_role_policy = <<EOF
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
EOF
}

# IAM Policy for Secrets Manager and KMS
resource "aws_iam_policy" "github_secrets_policy" {
  name        = "GitHubSecretsAccessPolicy"
  description = "Policy to allow GitHub integration with Secrets Manager and KMS"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetSecretValue"
      ],
      "Resource": "arn:aws:secretsmanager:${data.aws_caller_identity.current.account_id}:secret:${var.secrets_suffix}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:ListSecrets"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "kms:Decrypt",
      "Resource": "${data.aws_kms_key.default_secrets_manager_key.arn}"
    }
  ]
}
EOF
}

# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "attach_github_secrets_policy" {
  role       = aws_iam_role.github_secrets_role.name
  policy_arn = aws_iam_policy.github_secrets_policy.arn
}

