resource "aws_s3_bucket" "loki_bucket" {
  bucket = "cloud-loki-${var.environment}"

  tags = var.tags_loki_bucket
}

resource "aws_s3_bucket_policy" "loki_bucket" {
  count  = var.enable_loki_bucket_restriction ? 1 : 0
  bucket = aws_s3_bucket.loki_bucket.id
  policy = data.aws_iam_policy_document.loki_bucket_policy.json
}

resource "aws_s3_bucket_acl" "loki_bucket" {
  bucket = aws_s3_bucket.loki_bucket.id

  acl = "private"
}

resource "aws_s3_bucket_versioning" "loki_bucket" {
  bucket = aws_s3_bucket.loki_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "loki_bucket" {
  bucket = aws_s3_bucket.loki_bucket.id

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


data "aws_iam_policy_document" "loki_bucket_policy" {

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
      "arn:aws:s3:::cloud-loki-${var.environment}",
      "arn:aws:s3:::cloud-loki-${var.environment}/*"
    ]

    condition {
      test     = "StringNotLike"
      variable = "aws:userId"

      values = ["AROA*"]
    }
  }
}

resource "aws_s3_bucket" "loki_bucket_developers" {
  count  = var.enable_loki_bucket_developers ? 1 : 0
  bucket = "cloud-loki-developers-${var.environment}"

  tags = var.tags_bucket_loki_developers
}

resource "aws_s3_bucket_policy" "loki_bucket_developers" {
  count  = var.enable_loki_bucket_developers && var.enable_loki_bucket_developers_restriction ? 1 : 0
  bucket = aws_s3_bucket.loki_bucket_developers[0].id
  policy = data.aws_iam_policy_document.loki_bucket_developers_policy[0].json
}

resource "aws_s3_bucket_acl" "loki_bucket_developers" {
  count  = var.enable_loki_bucket_developers ? 1 : 0
  bucket = aws_s3_bucket.loki_bucket_developers[0].id

  acl = "private"
}

resource "aws_s3_bucket_versioning" "loki_bucket_developers" {
  count  = var.enable_loki_bucket_developers ? 1 : 0
  bucket = aws_s3_bucket.loki_bucket_developers[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "loki_bucket_developers" {
  count  = var.enable_loki_bucket_developers ? 1 : 0
  bucket = aws_s3_bucket.loki_bucket_developers[0].id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = data.aws_kms_key.master_s3.arn
      sse_algorithm     = "aws:kms"
    }
  }
}


data "aws_iam_policy_document" "loki_bucket_developers_policy" {
  count = var.enable_loki_bucket_developers ? 1 : 0

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
      "arn:aws:s3:::cloud-loki-developers-${var.environment}",
      "arn:aws:s3:::cloud-loki-developers-${var.environment}/*"
    ]

    condition {
      test     = "StringNotLike"
      variable = "aws:userId"

      values = ["AROA*"]
    }
  }
}
