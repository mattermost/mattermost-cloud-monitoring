resource "aws_s3_bucket" "mattermost-cloud-provisioning-bucket" {
  bucket = "${var.deployment_name}-${var.vpc_id}"
  tags = merge(
    {
      "Name" = "${var.deployment_name}-${var.vpc_id}"
    },
    var.tags
  )
}

resource "aws_s3_bucket_acl" "mattermost-cloud-provisioning-bucket" {
  bucket = aws_s3_bucket.mattermost-cloud-provisioning-bucket.id

  acl = "private"
}

resource "aws_s3_bucket_versioning" "mattermost-cloud-provisioning-bucket" {
  bucket = aws_s3_bucket.mattermost-cloud-provisioning-bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

