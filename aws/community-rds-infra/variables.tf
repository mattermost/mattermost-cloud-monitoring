variable "private_hosted_zoneid" {
  type        = string
  description = "The ID of the Route53 private hosted zone"
}

variable "rds_writer_hostname" {
  type        = string
  description = "The RDS writer hostname"
}

variable "rds_reader_hostnames" {
  type        = list(string)
  description = "The RDS reader hostname, must be 3 elements. The first element is the generic reader hostname, the second is the primary reader, and the third is the secondary reader."
}

variable "rds_reader_records" {
  type        = list(string)
  description = "The RDS reader records, must be 3 elements. The first element is the generic reader record, the second is the primary reader, and the third is the secondary reader."
  default     = ["community-db-ro", "community-db-reader1", "community-db-reader2"]
}
