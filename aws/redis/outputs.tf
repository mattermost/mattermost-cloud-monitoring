output "address" {
  description = "Primary endpoint of the replication group, used for CacheSettings.RedisAddress"
  value       = aws_elasticache_replication_group.redis.primary_endpoint_address
}

output "port" {
  description = "Port of the Redis primary endpoint"
  value       = aws_elasticache_replication_group.redis.port
}

output "security_group_id" {
  description = "ID of the security group attached to the Redis cluster"
  value       = aws_security_group.redis_sg.id
}

output "replication_group_id" {
  description = "ID of the replication group"
  value       = aws_elasticache_replication_group.redis.id
}

output "member_clusters" {
  description = "Cache cluster IDs in the replication group (the CacheClusterId CloudWatch dimension)"
  value       = aws_elasticache_replication_group.redis.member_clusters
}
