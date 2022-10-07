resource "aws_route53_record" "rds_writer" {
  zone_id = var.private_hosted_zoneid
  name    = "community-db"
  type    = "CNAME"
  ttl     = "60"
  records = [var.rds_writer_hostname]
}

resource "aws_route53_record" "rds_reader" {
  zone_id = var.private_hosted_zoneid
  name    = "community-db-ro"
  type    = "CNAME"
  ttl     = "60"
  records = [var.rds_reader_hostnames[0]]
}

resource "aws_route53_record" "rds_reader_1" {
  zone_id = var.private_hosted_zoneid
  name    = "community-db-reader1"
  type    = "CNAME"
  ttl     = "60"
  records = [var.rds_reader_hostnames[1]]
}

resource "aws_route53_record" "rds_reader_2" {
  zone_id = var.private_hosted_zoneid
  name    = "community-db-reader2"
  type    = "CNAME"
  ttl     = "60"
  records = [var.rds_reader_hostnames[2]]
}
