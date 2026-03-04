################################################################################
# S3 Buckets for Mimir Long-Term Storage
#
# Mimir stores TSDB blocks, alertmanager state, and ruler configs in S3.
################################################################################

data "aws_kms_key" "master_s3" {
  key_id = "alias/aws/s3"
}

# Blocks storage (time series data)
resource "aws_s3_bucket" "mimir_blocks" {
  bucket = "cloud-mimir-blocks-${var.environment}"
  tags = merge(var.tags, {
    Name      = "cloud-mimir-blocks-${var.environment}"
    Component = "mimir"
    ManagedBy = "terraform"
  })
}

resource "aws_s3_bucket_acl" "mimir_blocks" {
  bucket = aws_s3_bucket.mimir_blocks.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "mimir_blocks" {
  bucket = aws_s3_bucket.mimir_blocks.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "mimir_blocks" {
  bucket = aws_s3_bucket.mimir_blocks.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = data.aws_kms_key.master_s3.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "mimir_blocks" {
  bucket = aws_s3_bucket.mimir_blocks.id

  rule {
    id     = "transition-old-blocks"
    status = "Enabled"

    transition {
      days          = 90
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = 365
    }
  }
}

# Alertmanager storage
resource "aws_s3_bucket" "mimir_alertmanager" {
  bucket = "cloud-mimir-alertmanager-${var.environment}"
  tags = merge(var.tags, {
    Name      = "cloud-mimir-alertmanager-${var.environment}"
    Component = "mimir"
    ManagedBy = "terraform"
  })
}

resource "aws_s3_bucket_acl" "mimir_alertmanager" {
  bucket = aws_s3_bucket.mimir_alertmanager.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "mimir_alertmanager" {
  bucket = aws_s3_bucket.mimir_alertmanager.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = data.aws_kms_key.master_s3.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# Ruler storage
resource "aws_s3_bucket" "mimir_ruler" {
  bucket = "cloud-mimir-ruler-${var.environment}"
  tags = merge(var.tags, {
    Name      = "cloud-mimir-ruler-${var.environment}"
    Component = "mimir"
    ManagedBy = "terraform"
  })
}

resource "aws_s3_bucket_acl" "mimir_ruler" {
  bucket = aws_s3_bucket.mimir_ruler.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "mimir_ruler" {
  bucket = aws_s3_bucket.mimir_ruler.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = data.aws_kms_key.master_s3.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
