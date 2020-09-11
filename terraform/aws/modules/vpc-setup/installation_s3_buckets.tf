data "aws_kms_key" "master_s3" {
  key_id = "alias/aws/s3"
}

resource "aws_s3_bucket" "installation_buckets" {
  for_each = toset(var.vpc_cidrs)

  bucket = format("%s-%s", var.name, aws_vpc.vpc_creation[each.value]["id"])
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = data.aws_kms_key.master_s3.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled    = true
    mfa_delete = false
  }

  tags = merge(
    {
      "Name"  = format("%s-%s", var.name, aws_vpc.vpc_creation[each.value]["id"]),
      "VpcID" = aws_vpc.vpc_creation[each.value]["id"]
    },
    var.tags
  )
}

