output "config_map_aws_auth" {
  value = module.cluster.config_map_aws_auth
}

output "workers_security_group" {
  value = module.cluster.worker_security_group
}
