data "aws_kms_key" "master_s3" {
  key_id = "alias/aws/s3"
}

resource "aws_s3_bucket" "mattermost-cloud-provisioning-bucket" {
  bucket = "${var.deployment_name}-${var.vpc_id}"
  acl    = "private"
  tags = merge(
    {
      "Name" = "${var.deployment_name}-${var.vpc_id}"
    },
    var.tags
  )
  versioning {
    enabled    = true
    mfa_delete = false
  }
}