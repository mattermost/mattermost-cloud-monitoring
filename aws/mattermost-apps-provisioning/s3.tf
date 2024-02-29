resource "aws_s3_bucket" "bucket" {
  bucket = "${var.deployment_name}-assets-bucket-${var.environment}"
}

resource "aws_s3_bucket" "state_bucket" {
  bucket = "${var.deployment_name}-terraform-state-bucket-${var.environment}"
}

resource "aws_s3_bucket_acl" "state_bucket" {
  bucket = aws_s3_bucket.state_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_acl" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}
