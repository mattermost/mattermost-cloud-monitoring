variable "deployment_name" {
  description = "Name prefix for the gateway and its resources, e.g. \"core\""
  type        = string
}

variable "environment" {
  description = "Environment name, used as the API Gateway stage name"
  type        = string
}

variable "routes" {
  description = <<-EOT
    Public webhook routes to expose. The map key is the URL path segment, so a key
    of "github-cursor-webhook" is served at <invoke_url>/github-cursor-webhook.

    Each value points at the Lambda behind that route. The Lambda itself is created
    elsewhere; this module only adds the route and the invoke permission for it.
  EOT

  type = map(object({
    lambda_function_name = string
    lambda_invoke_arn    = string
  }))

  default = {}

  validation {
    # Path segments must be URL-safe, and the same string is reused as an IAM
    # statement ID (pattern [a-zA-Z0-9-_]+), so keep both happy.
    condition     = alltrue([for k in keys(var.routes) : can(regex("^[a-zA-Z0-9-_]+$", k))])
    error_message = "Route keys must contain only letters, numbers, hyphens and underscores."
  }
}

variable "throttling_rate_limit" {
  description = "Steady-state requests per second allowed per method, enforced at the edge before the Lambda is invoked. -1 disables throttling."
  type        = number
  default     = 50
}

variable "throttling_burst_limit" {
  description = "Burst capacity allowed per method, enforced at the edge before the Lambda is invoked. -1 disables throttling."
  type        = number
  default     = 100
}

variable "enable_access_logging" {
  description = <<-EOT
    Write API Gateway access logs to CloudWatch for this stage.

    Defaults to false because REST API access logging requires an account-level
    CloudWatch Logs role (API Gateway account setting `cloudwatchRoleArn`), which is
    an account-wide singleton and is deliberately not managed by this module. Enabling
    this before that role exists produces a stage that fails to deliver logs.

    CloudWatch *metrics* (request count, 4xx, 5xx, latency) are always enabled and
    need no such role.
  EOT

  type    = bool
  default = false
}

variable "log_retention_in_days" {
  description = "Retention for the access log group. Only used when enable_access_logging is true."
  type        = number
  default     = 30
}

variable "tags" {
  description = "Tags applied to the gateway, stage and log group"
  type        = map(string)
  default     = {}
}
