data "aws_kms_key" "master_s3" {
  key_id = "alias/aws/s3"
}

resource "aws_s3_bucket" "mattermost-cloud-provisioning-bucket" {
  bucket = "${var.deployment_name}-${var.vpc_id}"
   tags = merge (
     {
      "Name" = "${var.deployment_name}-${var.vpc_id}"
     }, 
   var.tags
   )
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encrypting-provisioning-bucket" {
  bucket = aws_s3_bucket.mattermost-cloud-provisioning-bucket.bucket

  rule {
     apply_server_side_encryption_by_default {
        kms_master_key_id = data.aws_kms_key.master_s3.arn
        sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "provisioning-bucket-versioning" {
  bucket = aws_s3_bucket.mattermost-cloud-provisioning-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.mattermost-cloud-provisioning-bucket.id
  acl    = "private"
}

resource "aws_iam_role" "replication" {
  count      = var.s3_cross_region_replication_enabled == true ? 1 : 0
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
  count      = var.s3_cross_region_replication_enabled == true ? 1 : 0
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
        "${aws_s3_bucket.mattermost-cloud-provisioning-bucket.arn}",
        "${aws_s3_bucket.mattermost-cloud-provisioning-bucket.arn}/*",
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
        "${aws_s3_bucket.mattermost-cloud-provisioning-bucket.arn}",
        "${aws_s3_bucket.mattermost-cloud-provisioning-bucket.arn}/*",
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
  count      = var.s3_cross_region_replication_enabled == true ? 1 : 0
  role       = aws_iam_role.replication[count.index].name
  policy_arn = aws_iam_policy.replication[count.index].arn
}

resource "aws_s3_bucket_replication_configuration" "source_to_dest" {
  # Must have bucket versioning enabled first
  count      = var.s3_cross_region_replication_enabled == true ? 1 : 0
  depends_on = [aws_s3_bucket_versioning.provisioning-bucket-versioning]

  role       = aws_iam_role.replication[count.index].arn
  bucket     = aws_s3_bucket.mattermost-cloud-provisioning-bucket.id

  rule {
    id     = "replicate-community-provisioning-data"
    prefix = ""
    status = "Enabled"
    
    source_selection_criteria {
      sse_kms_encrypted_objects {
        status = "Enabled"
      }
    }

    destination {
      bucket        = var.destination_bucket
      encryption_configuration {
           replica_kms_key_id = var.destination_s3_kms_key
      }
    }
  }
}
