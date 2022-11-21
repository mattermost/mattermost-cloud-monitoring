resource "aws_s3_bucket" "website_bucket" {
  bucket = var.domain_name
  acl    = "public-read"
  policy = data.aws_iam_policy_document.website_policy.json
  website {

    error_document = "index.html"
  }

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

resource "null_resource" "remove_and_upload_to_s3" {
  provisioner "local-exec" {
    command = "aws s3 sync ${path.module}/${var.folder_name} s3://${aws_s3_bucket.website_bucket.id}"
  }
}