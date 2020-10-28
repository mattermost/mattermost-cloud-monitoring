data "aws_route53_zone" "private" {
  zone_id = var.private_hosted_zoneid
}

resource "aws_s3_bucket" "kibana_redirect" {
  bucket = "kibana.${data.aws_route53_zone.private.name}"
  acl    = "private"

  website {
    redirect_all_requests_to = "https://${aws_elasticsearch_domain.es_domain.kibana_endpoint}"
  }

  tags = {
    "Environment" = var.environment
  }

}

data "aws_acm_certificate" "private" {
  domain      = "*.${data.aws_route53_zone.private.name}"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

resource "aws_s3_bucket_public_access_block" "kibana_redirect" {
  bucket                  = aws_s3_bucket.kibana_redirect.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true

}


resource "aws_route53_record" "kibana_redirect" {
  zone_id = var.private_hosted_zoneid

  name = "kibana"
  type = "A"

  alias {
    name                   = aws_cloudfront_distribution.kibana_redirect.domain_name
    zone_id                = aws_cloudfront_distribution.kibana_redirect.hosted_zone_id
    evaluate_target_health = false
  }
}


resource "aws_cloudfront_distribution" "kibana_redirect" {
  origin {
    domain_name = aws_s3_bucket.kibana_redirect.website_endpoint
    # origin_id   = "S3-kibana.${data.aws_route53_zone.private.name}"
    origin_id = "kibana.${data.aws_route53_zone.private.name}.s3-website-${data.aws_region.current.name}.amazonaws.com"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2", "TLSv1.1", "TLSv1"]
    }
  }

  comment         = "CDN for Kibana S3 Bucket (redirect)"
  enabled         = true
  is_ipv6_enabled = true
  aliases         = ["kibana.${data.aws_route53_zone.private.name}"]
  price_class     = "PriceClass_100"

  default_cache_behavior {
    target_origin_id = "kibana.${data.aws_route53_zone.private.name}.s3-website-${data.aws_region.current.name}.amazonaws.com"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }


  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.private.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.1_2016"
  }

  tags = {
    "Environment" = var.environment
  }
}
