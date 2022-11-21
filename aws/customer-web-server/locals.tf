locals {
  db_identifier_read_replica = "${var.cws_db_identifier}-read"
  timestamp_now              = formatdate("YYYY-MM-DD-hh-mm", timestamp())

}

