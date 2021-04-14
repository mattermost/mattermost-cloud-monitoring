locals {
  timestamp_now              = formatdate("YYYY-MM-DD-hh-mm", timestamp())
  db_identifier_read_replica = "${var.cws_db_identifier}-read"
  db_name_read_replica       = "${var.cws_db_name}-read"
}
