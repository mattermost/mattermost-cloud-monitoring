resource "aws_s3_bucket" "gitlab_runners" {
  bucket = "mattermost-cloud-gitlab-runners"

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

resource "aws_s3_bucket_acl" "gitlab_runners" {
  bucket = aws_s3_bucket.gitlab_runners.id
  acl    = "private"
}
