resource "aws_s3_bucket" "lambdas_bucket" {
  bucket = "mattermost-cloud-lambdas-${var.environment}"
  acl    = "private"

  versioning {
    enabled    = true
  }
}
