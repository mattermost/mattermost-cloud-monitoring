variable "bucket_name" {
  description = "The name of the S3 bucket to store the Mattermost Teams Tab app"
  type        = string
}

variable "certificate_arn" {
  description = "The ARN of the certificate to use for the CloudFront distribution"
  type        = string
}
