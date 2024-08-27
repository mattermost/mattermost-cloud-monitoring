variable "bucket_name" {
  description = "The name of the S3 bucket to store the Mattermost Teams Tab app"
  type        = string
}

variable "host_name" {
  description = "The hostname to redirect all requests to"
  type        = string
}