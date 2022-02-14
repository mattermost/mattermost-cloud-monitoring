output "endpoint" {
  value       = aws_elasticsearch_domain.es_domain.endpoint
  description = "The Domain-specific endpoint used to submit index, search, and data upload requests."
}
