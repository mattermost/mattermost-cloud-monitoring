output "config_map_aws_auth" {
  value = local.config_map_aws_auth
}

output "worker_security_group" {
  value = aws_security_group.worker-sg.id
}
