output "config_map_aws_auth" {
  value = local.config_map_aws_auth
}

output "worker_role_arn" {
  value = aws_iam_role.worker-role.arn
}
