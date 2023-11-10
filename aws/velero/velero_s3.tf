data "aws_kms_key" "master_s3" {
  key_id = "alias/aws/s3"
}

resource "aws_s3_bucket" "velero_bucket" {
  bucket = "cloud-velero-${var.environment}"
}
resource "aws_s3_bucket_versioning" "velero_bucket" {
  bucket = aws_s3_bucket.velero_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "velero_bucket" {
  bucket = aws_s3_bucket.velero_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = data.aws_kms_key.master_s3.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
