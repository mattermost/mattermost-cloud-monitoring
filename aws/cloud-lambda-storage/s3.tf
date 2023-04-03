resource "aws_s3_bucket" "lambdas_bucket" {
  bucket = "mattermost-cloud-lambdas-${var.environment}"
}

resource "aws_s3_bucket_acl" "lambdas_bucket" {
  bucket = aws_s3_bucket.lambdas_bucket.id

  acl    = "private"
}

resource "aws_s3_bucket_versioning" "lambdas_bucket" {
  bucket = aws_s3_bucket.lambdas_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
