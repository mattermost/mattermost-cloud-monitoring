resource "aws_s3_bucket" "buckets" {
  for_each      = toset(var.s3_buckets)
  bucket        = each.key
  force_destroy = var.force_destroy

  tags = lookup(var.s3_bucket_tags, each.key, {})
}

resource "aws_s3_bucket_server_side_encryption_configuration" "buckets_sse" {
  for_each = aws_s3_bucket.buckets

  bucket = each.value.id

  rule {
    bucket_key_enabled = lookup(var.s3_bucket_encryption[each.key], "bucket_key_enabled", false)

    apply_server_side_encryption_by_default {
      sse_algorithm = lookup(var.s3_bucket_encryption[each.key], "sse_algorithm", "AES256")

      kms_master_key_id = lookup(var.s3_bucket_encryption[each.key], "sse_algorithm", "") == "aws:kms" ? lookup(var.s3_bucket_encryption[each.key], "kms_master_key_id", null) : null
    }
  }
}

resource "aws_s3_bucket_policy" "buckets_policy" {
  for_each = { for bucket_name, bucket_resource in aws_s3_bucket.buckets : bucket_name => bucket_resource if lookup(var.s3_bucket_policies, bucket_name, null) != null }

  bucket = each.value.id

  policy = lookup(var.s3_bucket_policies, each.key, "")
}
