resource "aws_route53_record" "rds_writer" {
  zone_id = var.private_hosted_zoneid
  name    = "community-db"
  type    = "CNAME"
  ttl     = "60"
  records = [var.rds_writer_hostname]
}

resource "aws_route53_record" "rds_reader" {
  count = length(var.rds_reader_hostnames)

  zone_id = var.private_hosted_zoneid
  name    = var.rds_reader_records[count.index]
  type    = "CNAME"
  ttl     = "60"
  records = [var.rds_reader_hostnames[count.index]]
}
