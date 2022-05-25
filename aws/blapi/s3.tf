resource "aws_s3_bucket" "pipelinewise" {
  bucket = "mm-bizops-data-${var.environment}"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = data.aws_kms_key.master_s3.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled    = true
    mfa_delete = false
  }
}

data "aws_kms_key" "master_s3" {
  key_id = "alias/aws/s3"
}
