resource "aws_s3_bucket" "loki_bucket" {
  bucket = "cloud-loki-${var.environment}"
  acl    = "private"
  policy = var.enable_loki_bucket_restriction ? data.aws_iam_policy_document.loki_bucket_policy.json : ""

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

data "aws_iam_user" "cnc_user" {
  user_name = var.cnc_user
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

  statement {
    effect = "Allow"
    actions = [
      "s3:*"
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
      test     = "StringLike"
      variable = "aws:userId"

      values = [
        data.aws_iam_user.cnc_user.user_id
      ]
    }
  }

}
