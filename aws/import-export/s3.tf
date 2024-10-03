resource "aws_s3_bucket" "buckets" {
  for_each = toset(var.s3_buckets)
  bucket   = each.key
}

resource "aws_s3_bucket_server_side_encryption_configuration" "buckets_sse" {
  for_each = aws_s3_bucket.buckets

  bucket = each.value.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.customer_managed.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_policy" "buckets_policy" {
  # Filter for buckets that have a policy in var.s3_bucket_policies
  for_each = { for bucket_name, bucket_resource in aws_s3_bucket.buckets : bucket_name => bucket_resource if lookup(var.s3_bucket_policies, bucket_name, null) != null }

  bucket = each.value.id

  # Use the policy defined in the variable map
  policy = lookup(var.s3_bucket_policies, each.key, "")
}
