variable "private_subnet_ids" {
  type        = list(string)
  description = "The list of the private subnet IDs"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the vpc for the security group of Lambda"
}

variable "deployment_name" {
  type        = string
  description = "The name of the deployment for Lambda"
}

variable "write_address" {
  type        = string
  description = "This is the Loki Write API compatible endpoint that you want to write logs to, either promtail or Loki."
  default     = "http://localhost:8080/loki/api/v1/push"
}

variable "log_group_names" {
  type        = list(string)
  description = "List of CloudWatch Log Group names to create Subscription Filters for."
  default     = []
}

variable "username" {
  type        = string
  description = "The basic auth username, necessary if writing directly to Grafana Cloud Loki."
  default     = ""
}

variable "password" {
  type        = string
  description = "The basic auth password, necessary if writing directly to Grafana Cloud Loki."
  sensitive   = true
  default     = ""
}

variable "tenant_id" {
  type        = string
  description = "Tenant ID to be added when writing logs from lambda-promtail."
  default     = ""
}

variable "keep_stream" {
  type        = string
  description = "Determines whether to keep the CloudWatch Log Stream value as a Loki label when writing logs from lambda-promtail."
  default     = "false"
}

variable "extra_labels" {
  type        = string
  description = "Comma separated list of extra labels, in the format 'name1,value1,name2,value2,...,nameN,valueN' to add to entries forwarded by lambda-promtail."
  default     = ""
}

variable "batch_size" {
  type        = string
  description = "Determines when to flush the batch of logs (bytes)."
  default     = ""
}

variable "filter_pattern" {
  type        = string
  description = "Determines pattern to parse logs."
  default     = ""
}

variable "include_message" {
  type        = string
  description = "Determines whether to include message as a Loki label when writing logs from lambda-promtail."
  default     = "false"
}

variable "promtail_lambda_iam_role" {
  type    = string
  default = "promtail_lambda"
}

variable "function_name" {
  type    = string
  default = "lambda-promtail"
}

variable "cloudwatch_log_group" {
  type    = string
  default = "/aws/lambda/lambda_promtail"
}

variable "lambda_s3_bucket" {
  type        = string
  description = "The S3 bucket where the lambda function is stored"
}

variable "lambda_s3_key" {
  type        = string
  description = "The S3 key where the lambda function is stored"
}
