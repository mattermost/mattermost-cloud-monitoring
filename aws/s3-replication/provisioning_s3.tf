data "aws_kms_key" "master_s3" {
  key_id = "alias/aws/s3"
}

data "aws_s3_bucket" "source" {
  bucket = var.source_bucket
}

resource "aws_s3_bucket" "mattermost-cloud-provisioning-dest-bucket" {
  provider = aws.destination
  bucket   = "${var.deployment_name}-${var.vpc_id}"
  tags = merge(
    {
      "Name" = "${var.deployment_name}-${var.vpc_id}-destination"
    },
    var.tags
  )
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encrypting-provisioning-bucket" {
  provider = aws.destination
  bucket   = aws_s3_bucket.mattermost-cloud-provisioning-dest-bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = data.aws_kms_key.master_s3.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "provisioning-bucket-versioning" {
  provider = aws.destination
  bucket   = aws_s3_bucket.mattermost-cloud-provisioning-dest-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  provider = aws.destination
  bucket   = aws_s3_bucket.mattermost-cloud-provisioning-dest-bucket.id
  acl      = "private"
}

resource "aws_iam_role" "replication" {
  name = "replication-role-${var.vpc_id}"

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
  name = "replication-policy-${var.vpc_id}"

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
        "${aws_s3_bucket.mattermost-cloud-provisioning-dest-bucket.arn}",
        "${aws_s3_bucket.mattermost-cloud-provisioning-dest-bucket.arn}/*",
        "${data.aws_s3_bucket.source.arn}",
        "${data.aws_s3_bucket.source.arn}/*"
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
        "${aws_s3_bucket.mattermost-cloud-provisioning-dest-bucket.arn}",
        "${aws_s3_bucket.mattermost-cloud-provisioning-dest-bucket.arn}/*",
        "${data.aws_s3_bucket.source.arn}",
        "${data.aws_s3_bucket.source.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ReplicateTags"
      ],
      "Effect": "Allow",
      "Resource": "${data.aws_s3_bucket.source.arn}/*"
    }
   
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}



resource "aws_s3_bucket_replication_configuration" "source_to_dest" {
  # Must have bucket versioning enabled first
  provider = aws.source
  role     = aws_iam_role.replication.arn
  bucket   = data.aws_s3_bucket.source.id

  rule {
    id     = "replicate-community-provisioning-data"
    status = "Enabled"
    source_selection_criteria {
      sse_kms_encrypted_objects {
        status = "Enabled"
      }
    }

    destination {
      bucket = aws_s3_bucket.mattermost-cloud-provisioning-dest-bucket.arn
      encryption_configuration {
        replica_kms_key_id = var.destination_s3_kms_key
      }
    }
  }
}
