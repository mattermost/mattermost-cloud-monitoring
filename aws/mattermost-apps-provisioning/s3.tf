resource "aws_s3_bucket" "bucket" {
  bucket = "${var.deployment_name}-assets-bucket-${var.environment}"
  acl    = "private"
}

resource "aws_s3_bucket" "state_bucket" {
  bucket = "${var.deployment_name}-terraform-state-bucket-${var.environment}"
  acl    = "private"
}
