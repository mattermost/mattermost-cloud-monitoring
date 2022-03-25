data "aws_kms_key" "master_s3" {
  key_id = "alias/aws/s3"
}

resource "aws_s3_bucket" "mattermost-cloud-staging-provisioning-bucket" {
  bucket = "${var.deployment_name}-${var.vpc_id}"
}

resource "aws_s3_bucket_versioning" "provisioning-bucket-versioning" {
  bucket = aws_s3_bucket.mattermost-cloud-staging-provisioning-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.mattermost-cloud-staging-provisioning-bucket.id
  acl    = "private"
}

resource "aws_iam_role" "replication" {
  name = "role-replication"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "replication" {
  name = "policy-replication"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.mattermost-cloud-staging-provisioning-bucket.arn}",
        "${aws_s3_bucket.mattermost-cloud-staging-provisioning-bucket.arn}/*",
        "${var.destination_bucket}",
        "${var.destination_bucket}/*"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersionForReplication",
        "s3:GetObjectVersionAcl",
         "s3:GetObjectVersionTagging"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.mattermost-cloud-staging-provisioning-bucket.arn}",
        "${aws_s3_bucket.mattermost-cloud-staging-provisioning-bucket.arn}/*",
        "${var.destination_bucket}",
        "${var.destination_bucket}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ReplicateTags"
      ],
      "Effect": "Allow",
      "Resource": "${var.destination_bucket}/*"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}

resource "aws_s3_bucket_replication_configuration" "west_to_east" {
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.provisioning-bucket-versioning]

  role   = aws_iam_role.replication.arn
  bucket = aws_s3_bucket.mattermost-cloud-staging-provisioning-bucket.id

  rule {
    id     = "replicate-community-provisioning-data"
    prefix = ""
    status = "Enabled"

    destination {
      bucket        = var.destination_bucket
      # storage_class = "STANDARD"
    }
  }
}
