resource "aws_s3_bucket" "pipelinewise" {
  bucket = "mm-bizops-data-${var.environment}"
}

data "aws_kms_key" "master_s3" {
  key_id = "alias/aws/s3"
}

resource "aws_s3_bucket_acl" "pipelinewise" {
  bucket = aws_s3_bucket.pipelinewise.id

  acl = "private"
}

resource "aws_s3_bucket_versioning" "pipelinewise" {
  bucket = aws_s3_bucket.pipelinewise.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "pipelinewise" {
  bucket = aws_s3_bucket.pipelinewise.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = data.aws_kms_key.master_s3.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
