resource "aws_s3_bucket" "metrics_bucket" {
  bucket = "cloud-${var.environment}-prometheus-metrics"
}

resource "aws_s3_bucket_acl" "metrics_bucket" {
  bucket = aws_s3_bucket.metrics_bucket.id
  acl    = "private"
}
