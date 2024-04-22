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

resource "random_password" "external-secrets-app-secrets" {
  # Flatten the structure to get a set of unique identifiers for each app-key combination, including the specified length
  for_each = toset(flatten([
    for app, details in var.applications : [
      for key in details.keys : "${app}-${key.name}-${key.length}"
    ]
  ]))

  # Use the custom length specified for each key, defaulting to 16 if not specified
  length           = tonumber(split("-", each.key)[2])
  special          = true
  override_special = "_%@"
}


resource "aws_secretsmanager_secret" "external-secrets-app-secret" {
  for_each = var.applications

  name        = "app-${each.key}"
  description = "Secrets for application ${each.key}"
}

resource "aws_secretsmanager_secret_version" "external-secrets-app-secret-version" {
  for_each = { for app, details in var.applications : app => details }

  secret_id = aws_secretsmanager_secret.external-secrets-app-secret[each.key].id
  secret_string = jsonencode({
    for key in each.value.keys : key.name => random_password.external-secrets-app-secrets["${each.key}-${key.name}-${key.length}"].result
  })

  lifecycle {
    ignore_changes = [secret_string]
  }
}


resource "aws_iam_policy" "external-secrets-policy" {
  name        = "external-secrets-policy"
  path        = "/"
  description = "Permissions for external-secrets role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:ListSecretVersionIds"
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
