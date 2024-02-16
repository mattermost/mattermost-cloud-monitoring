resource "aws_iam_role" "external-secrets-role" {
  name               = "k8s-${var.environment}-external-secrets"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Federated": "${var.open_oidc_provider_arn}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${var.open_oidc_provider_url}:sub": "system:serviceaccount:${var.namespace}:${var.serviceaccount}"
        }
      }
    }
  ]
}
EOF
}

resource "aws_secretsmanager_secret" "external-secrets-app-secret" {
  for_each = var.applications

  name        = "app-${each.key}"
  description = "Secret for application ${each.key}"
}

resource "aws_secretsmanager_secret_version" "external-secrets-app-secret-version" {
  for_each = var.applications

  secret_id     = aws_secretsmanager_secret.external-secrets-app-secret[each.key].id
  secret_string = jsonencode({for k, v in zipmap(each.value.keys, each.value.values) : k => v})
}

resource "aws_iam_policy" "external-secrets-policy" {
  name        = "external-secrets-policy"
  path        = "/"
  description = "Permissions for external-secrets role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
        ]
        Resource = [
          for app in keys(var.applications) : aws_secretsmanager_secret.external-secrets-app-secret[app].arn
        ]
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "secret_access_attachment" {
  role       = aws_iam_role.external-secrets-role.name
  policy_arn = aws_iam_policy.external-secrets-policy.arn
}
