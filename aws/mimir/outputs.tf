output "msk_cluster_arn" {
  description = "ARN of the MSK Serverless cluster"
  value       = var.enable_msk ? aws_msk_serverless_cluster.mimir_ingest[0].arn : null
}

output "msk_bootstrap_brokers" {
  description = "MSK Serverless bootstrap brokers. Use 'aws kafka get-bootstrap-brokers --cluster-arn <arn>' to retrieve the actual endpoint."
  value       = var.enable_msk ? aws_msk_serverless_cluster.mimir_ingest[0].arn : null
}

output "msk_security_group_id" {
  description = "Security group ID for the MSK cluster"
  value       = var.enable_msk ? aws_security_group.msk_mimir[0].id : null
}

output "mimir_blocks_bucket_id" {
  description = "S3 bucket ID for Mimir blocks storage"
  value       = aws_s3_bucket.mimir_blocks.id
}

output "mimir_blocks_bucket_arn" {
  description = "S3 bucket ARN for Mimir blocks storage"
  value       = aws_s3_bucket.mimir_blocks.arn
}

output "mimir_alertmanager_bucket_id" {
  description = "S3 bucket ID for Mimir alertmanager storage"
  value       = aws_s3_bucket.mimir_alertmanager.id
}

output "mimir_alertmanager_bucket_arn" {
  description = "S3 bucket ARN for Mimir alertmanager storage"
  value       = aws_s3_bucket.mimir_alertmanager.arn
}

output "mimir_ruler_bucket_id" {
  description = "S3 bucket ID for Mimir ruler storage"
  value       = aws_s3_bucket.mimir_ruler.id
}

output "mimir_ruler_bucket_arn" {
  description = "S3 bucket ARN for Mimir ruler storage"
  value       = aws_s3_bucket.mimir_ruler.arn
}

output "mimir_iam_policy_arn" {
  description = "IAM policy ARN for Mimir pods (attach via IRSA)"
  value       = aws_iam_policy.mimir.arn
}
