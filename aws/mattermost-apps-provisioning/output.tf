output "mattermost_apps_lambda_role" {
  value = aws_iam_role.lambda_role
}

output "mattermost_apps_security_group" {
  value = aws_security_group.lambda_sg
}

