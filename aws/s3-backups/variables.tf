variable "s3_backup_cron" {
  type = string
}

variable "s3_backup_kms_key" {
  type = string
}

variable "s3_backup_retention" {
  type = number
}

variable "name" {
  type = string
}

variable "vpc_cidrs" {
  type = list(string)
}
