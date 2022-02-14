data "aws_kms_key" "master_s3" {
  key_id = "alias/aws/s3"
}

data "aws_iam_user" "cnc_user" {
  user_name = var.cnc_user
}

resource "aws_s3_bucket" "state_bucket" {
  bucket = "mattermost-kops-state-${var.environment}${local.conditional_dash_region}"
  acl    = "private"
  policy = data.aws_iam_policy_document.state_bucket_policy.json

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = data.aws_kms_key.master_s3.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  force_destroy = var.force_destroy_state_bucket

  versioning {
    enabled    = true
    mfa_delete = false
  }
}

data "aws_iam_policy_document" "state_bucket_policy" {

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
      "arn:aws:s3:::mattermost-kops-state-${var.environment}${local.conditional_dash_region}",
      "arn:aws:s3:::mattermost-kops-state-${var.environment}${local.conditional_dash_region}/*"
    ]

    condition {
      test     = "StringNotLike"
      variable = "aws:userId"

      values = flatten([[
        for provisioner_user in var.provisioner_users :
        aws_iam_user.provisioner_users[provisioner_user].unique_id
      ], ["AROA*"]])
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
      "arn:aws:s3:::mattermost-kops-state-${var.environment}${local.conditional_dash_region}",
      "arn:aws:s3:::mattermost-kops-state-${var.environment}${local.conditional_dash_region}/*"
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
