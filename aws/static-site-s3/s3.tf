module "template_files" {
  source   = "hashicorp/dir/template"
  version  = "1.0.2"
  base_dir = "${var.filepath}/${var.folder_name}"
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = var.domain_name
  policy = data.aws_iam_policy_document.website_policy.json

  tags = var.tags

  force_destroy = var.force_destroy
}

resource "aws_s3_bucket_cors_configuration" "website" {
  bucket = aws_s3_bucket.website_bucket.id

  cors_rule {
    allowed_headers = ["Authorization"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_acl" "website" {
  bucket = aws_s3_bucket.website_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website_bucket.bucket
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}

resource "aws_s3_bucket_object" "static_files" {
  for_each = module.template_files.files

  bucket       = aws_s3_bucket.website_bucket.bucket
  key          = each.key
  content_type = each.value.content_type

  # The template_files module guarantees that only one of these two attributes
  # will be set for each file, depending on whether it is an in-memory template
  # rendering result or a static file on disk.
  source = each.value.source_path

  # Unless the bucket has encryption enabled, the ETag of each object is an
  # MD5 hash of that object.
  etag = each.value.digests.md5
}
