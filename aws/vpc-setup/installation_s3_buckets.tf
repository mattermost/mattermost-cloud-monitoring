data "aws_kms_key" "master_s3" {
  key_id = "alias/aws/s3"
}

resource "aws_s3_bucket" "installation_buckets" {
  for_each = toset(var.vpc_cidrs)

  bucket = format("%s-%s", var.name, aws_vpc.vpc_creation[each.value]["id"])

  tags = merge(
    {
      "Name"      = format("%s-%s", var.name, aws_vpc.vpc_creation[each.value]["id"]),
      "VpcID"     = aws_vpc.vpc_creation[each.value]["id"],
      "Filestore" = "Multitenant"
    },
    var.tags
  )
  lifecycle {
    ignore_changes = [
      replication_configuration
    ]
  }
}

resource "aws_s3_bucket_acl" "installation_buckets" {
  for_each = toset(var.vpc_cidrs)
  bucket   = aws_s3_bucket.installation_buckets.id[each.key]

  acl = "private"
}

resource "aws_s3_bucket_versioning" "installation_buckets" {
  for_each = toset(var.vpc_cidrs)
  bucket   = aws_s3_bucket.installation_buckets.id[each.key]

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "installation_buckets" {
  for_each = toset(var.vpc_cidrs)
  bucket   = aws_s3_bucket.installation_buckets.id[each.key]

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = data.aws_kms_key.master_s3.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
