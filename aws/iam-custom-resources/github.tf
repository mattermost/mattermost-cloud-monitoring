variable "environment" {
  type        = string
  description = "Environment name for the OIDC provider"
}

resource "aws_iam_openid_connect_provider" "github_oidc" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
  ]

  tags = {
    Environment = var.environment
    Name        = "github-actions-oidc-${var.environment}"
  }
}

output "github_oidc_provider_arn" {
  value       = aws_iam_openid_connect_provider.github_oidc.arn
  description = "ARN of the GitHub Actions OIDC provider"
}
