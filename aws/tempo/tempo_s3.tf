resource "aws_s3_bucket" "tempo_bucket" {
  bucket = "cloud-tempo-${var.environment}"

  tags = var.tempo_bucket_tags
}

resource "aws_s3_bucket_policy" "tempo_bucket" {
  count  = var.enable_tempo_bucket_restriction ? 1 : 0
  bucket = aws_s3_bucket.tempo_bucket.id
  policy = data.aws_iam_policy_document.tempo_bucket_policy.json
}

resource "aws_s3_bucket_acl" "tempo_bucket" {
  bucket = aws_s3_bucket.tempo_bucket.id

  acl = "private"
}

resource "aws_s3_bucket_versioning" "tempo_bucket" {
  bucket = aws_s3_bucket.tempo_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tempo_bucket" {
  bucket = aws_s3_bucket.tempo_bucket.id

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


data "aws_iam_policy_document" "tempo_bucket_policy" {

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
      "arn:aws:s3:::cloud-tempo-${var.environment}",
      "arn:aws:s3:::cloud-tempo-${var.environment}/*"
    ]

    condition {
      test     = "StringNotLike"
      variable = "aws:userId"

      values = flatten([[
        aws_iam_user.tempo_user.unique_id
      ], ["AROA*"]])
    }
  }
}

