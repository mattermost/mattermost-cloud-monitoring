resource "aws_s3_bucket" "metrics_bucket" {
  bucket = "cloud-${var.environment}-prometheus-metrics"
  region = "us-east-1"
  acl    = "private"
}
