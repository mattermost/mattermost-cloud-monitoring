output "address" {
  description = "DNS name of the Redis node, used for CacheSettings.RedisAddress"
  value       = aws_elasticache_cluster.redis_cluster.cache_nodes[0].address
}

output "port" {
  description = "Port of the Redis node"
  value       = aws_elasticache_cluster.redis_cluster.port
}

output "security_group_id" {
  description = "ID of the security group attached to the Redis cluster"
  value       = aws_security_group.redis_sg.id
}
