variable "bucket_name" {
  description = "The name of the S3 bucket to store the Mattermost Teams Tab app"
  type        = string
}

variable "certificate_arn" {
  description = "The ARN of the certificate to use for the CloudFront distribution"
  type        = string
}

variable "s3_origin_id" {
  description = "The ID of the S3 origin in the CloudFront distribution"
  type        = string
  default     = "teamsTabS3Origin"
}

variable "enable_cloudfront" {
  description = "Whether to enable the CloudFront distribution"
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Whether to enable versioning on the S3 bucket"
  type        = bool
  default     = true
}
