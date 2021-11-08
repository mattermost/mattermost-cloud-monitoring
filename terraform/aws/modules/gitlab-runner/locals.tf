data "aws_caller_identity" "current" {}

data "aws_kms_key" "master_s3" {
  key_id = "alias/aws/s3"
}
