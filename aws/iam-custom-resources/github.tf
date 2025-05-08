resource "aws_iam_openid_connect_provider" "github_oidc" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]

  tags = {
    Environment = var.environment
    Name        = "github-actions-oidc-${var.environment}"
  }
}

output "github_oidc_provider_arn" {
  value       = aws_iam_openid_connect_provider.github_oidc.arn
  description = "ARN of the GitHub Actions OIDC provider"
}
