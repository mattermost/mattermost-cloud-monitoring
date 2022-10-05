data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_acm_certificate" "internal_cert" {
  domain      = "*.internal.${var.environment}.cloud.mattermost.com"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

resource "aws_elasticsearch_domain" "es_domain" {
  domain_name           = var.domain_name
  elasticsearch_version = var.es_version

  cluster_config {
    instance_type            = var.es_instance_type
    instance_count           = var.instance_count
    dedicated_master_enabled = var.dedicated_master_enabled
    dedicated_master_count   = var.dedicated_master_count
    dedicated_master_type    = var.dedicated_master_type
    zone_awareness_enabled   = var.es_zone_awareness
    zone_awareness_config {
      availability_zone_count = var.es_zone_awareness_count
    }
  }

  domain_endpoint_options {
    custom_endpoint_enabled         = var.custom_endpoint_enabled
    custom_endpoint                 = "elasticsearch.internal.${var.environment}.cloud.mattermost.com"
    custom_endpoint_certificate_arn = data.aws_acm_certificate.internal_cert.arn
    tls_security_policy             = var.tls_security_policy
  }

  vpc_options {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [aws_security_group.es_sg.id]
  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  access_policies = <<CONFIG
  {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": ${jsonencode(var.elasticsearch_access_policy_principal)}
      },
      "Action": "es:*",
      "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.domain_name}/*"
    }
  ]
  }
  CONFIG

  snapshot_options {
    automated_snapshot_start_hour = 23
  }

  log_publishing_options {
    cloudwatch_log_group_arn = "${aws_cloudwatch_log_group.es_group.arn}:*"
    log_type                 = "INDEX_SLOW_LOGS"
  }

  log_publishing_options {
    cloudwatch_log_group_arn = "${aws_cloudwatch_log_group.es_group.arn}:*"
    log_type                 = "SEARCH_SLOW_LOGS"
  }

  log_publishing_options {
    cloudwatch_log_group_arn = "${aws_cloudwatch_log_group.es_group.arn}:*"
    log_type                 = "ES_APPLICATION_LOGS"
  }

  ebs_options {
    ebs_enabled = true
    volume_size = var.es_volume_size
  }

  tags = {
    "Environment" = var.environment
  }
}

resource "aws_route53_record" "elasticsearch" {
  zone_id = var.private_hosted_zoneid
  name    = "elasticsearch"
  type    = "CNAME"
  ttl     = "60"
  records = [aws_elasticsearch_domain.es_domain.endpoint]
}
