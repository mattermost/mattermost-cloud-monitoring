resource "aws_s3_bucket" "awat_bucket" {
  bucket = "cloud-awat-${var.environment}"

  tags = var.awat_bucket_tags
}

resource "aws_s3_bucket_policy" "awat_bucket" {
  count  = var.enable_awat_bucket_restriction ? 1 : 0
  bucket = aws_s3_bucket.awat_bucket.id
  policy = data.aws_iam_policy_document.awat_bucket_policy.json
}

resource "aws_s3_bucket_acl" "awat_bucket" {
  bucket = aws_s3_bucket.awat_bucket.id

  acl = "private"
}

resource "aws_s3_bucket_versioning" "awat_bucket" {
  bucket = aws_s3_bucket.awat_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "awat_bucket" {
  bucket = aws_s3_bucket.awat_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = data.aws_kms_key.master_s3.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

data "aws_kms_key" "master_s3" {
  key_id = "alias/aws/s3"
}

data "aws_iam_policy_document" "awat_bucket_policy" {

  statement {
    effect = "Deny"
    actions = [
      "s3:GetObject*",
      "s3:DeleteObject*"
    ]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    resources = [
      "arn:aws:s3:::cloud-awat-${var.environment}",
      "arn:aws:s3:::cloud-awat-${var.environment}/*"
    ]

    condition {
      test     = "StringNotLike"
      variable = "aws:userId"

      values = flatten([["AROA*"]])
    }
  }
}

