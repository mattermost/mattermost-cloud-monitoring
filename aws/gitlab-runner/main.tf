resource "aws_s3_bucket" "gitlab_runners" {
  bucket = "mattermost-cloud-gitlab-runners"
}

resource "aws_s3_bucket_acl" "gitlab_runners" {
  bucket = aws_s3_bucket.gitlab_runners.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "gitlab_runners" {
  bucket = aws_s3_bucket.gitlab_runners.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = data.aws_kms_key.master_s3.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "gitlab_runners" {
  bucket = aws_s3_bucket.gitlab_runners.id
  versioning_configuration {
    status     = "Enabled"
    mfa_delete = "Disabled"
  }
}
