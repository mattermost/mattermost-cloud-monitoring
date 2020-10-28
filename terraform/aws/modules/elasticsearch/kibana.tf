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
    name                   = aws_s3_bucket.kibana_redirect.website_domain
    zone_id                = aws_s3_bucket.kibana_redirect.hosted_zone_id
    evaluate_target_health = false
  }
}
