variable "environment" {
  type        = string
  description = "The name of the environment which will deploy to and will be added as a tag"
}

variable "github_runners_iam_role_arn" {
  type        = string
  description = "The ARN of the IAM role for the GitHub runners"
  default     = ""
}
