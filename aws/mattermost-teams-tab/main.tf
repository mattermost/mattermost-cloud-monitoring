resource "aws_s3_bucket" "static_website" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_ownership_controls" "static_website_acl" {
  bucket = aws_s3_bucket.static_website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "publiceaccess" {
  bucket                  = aws_s3_bucket.static_website.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "static_website_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.static_website_acl,
    aws_s3_bucket_public_access_block.publiceaccess,
  ]

  bucket = aws_s3_bucket.static_website.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "static_website_config" {
  bucket = aws_s3_bucket.static_website.id


  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}

resource "aws_s3_bucket_policy" "static_website_policy" {
  bucket = aws_s3_bucket.static_website.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.static_website.arn}/*",
      },
    ],
  })
}

resource "aws_iam_user" "teams_tab_user" {
  name = "mattermost-teams-tab"
}

resource "aws_iam_policy" "teams_tab_policy" {
  name        = "teams-tab-policy"
  description = "A policy to allow access to the S3 bucket"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "s3:PutObjectAcl",
          "s3:DeleteObject"
        ],
        Resource = [
          "arn:aws:s3:::${var.bucket_name}",
          "arn:aws:s3:::${var.bucket_name}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "teams_tab_policy_attachment" {
  user       = aws_iam_user.teams_tab_user.name
  policy_arn = aws_iam_policy.teams_tab_policy.arn
}

#### CLOUDFRONT DISTRIBUTION ####
resource "aws_cloudfront_origin_access_identity" "s3" {
  comment = "Origin Access Identity for mattermost teams tab S3"
}

resource "aws_cloudfront_distribution" "static_website_distribution" {
  origin {
    domain_name = aws_s3_bucket_website_configuration.static_website_config.website_endpoint
    origin_id   = "S3-${aws_s3_bucket.static_website.bucket_prefix}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.s3.id
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${aws_s3_bucket.static_website.bucket_prefix}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  # CloudFront Viewer Certificate
  viewer_certificate {
    acm_certificate_arn = var.certificate_arn
    ssl_support_method  = "sni-only"
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
