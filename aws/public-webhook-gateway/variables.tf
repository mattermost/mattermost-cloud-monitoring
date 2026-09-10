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

  validation {
    # Path segments must be URL-safe, and the same string is reused as an IAM
    # statement ID (pattern [a-zA-Z0-9-_]+), so keep both happy.
    condition     = alltrue([for k in keys(var.routes) : can(regex("^[a-zA-Z0-9-_]+$", k))])
    error_message = "Route keys must contain only letters, numbers, hyphens and underscores."
  }

  validation {
    # An API Gateway deployment with no methods is rejected at apply time
    # ("The REST API doesn't contain any methods"), so fail fast in plan instead.
    # This is also why the variable has no default: an empty map is never valid.
    condition     = length(var.routes) > 0
    error_message = "At least one route is required; an API Gateway deployment with no methods cannot be created."
  }
}

variable "throttling_rate_limit" {
  description = <<-EOT
    Steady-state requests per second allowed per method, enforced at the edge before
    the Lambda is invoked.

    -1 disables throttling. Be deliberate about that on a public endpoint: edge
    throttling is the main reason to put this gateway in front of a Lambda that
    already authenticates its own requests, so -1 gives up the protection this
    module exists to provide.
  EOT

  type    = number
  default = 50

  validation {
    condition     = var.throttling_rate_limit == -1 || var.throttling_rate_limit > 0
    error_message = "throttling_rate_limit must be greater than 0, or exactly -1 to disable throttling. 0 would reject all traffic."
  }
}

variable "throttling_burst_limit" {
  description = "Burst capacity allowed per method, enforced at the edge before the Lambda is invoked. -1 disables throttling; see the warning on throttling_rate_limit."
  type        = number
  default     = 100

  validation {
    condition     = var.throttling_burst_limit == -1 || var.throttling_burst_limit > 0
    error_message = "throttling_burst_limit must be greater than 0, or exactly -1 to disable throttling. 0 would reject all traffic."
  }
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
  description = "Retention for the access log group, in days. 0 means never expire. Only used when enable_access_logging is true."
  type        = number
  default     = 30

  validation {
    # CloudWatch Logs accepts only this fixed set; anything else fails at apply.
    condition = contains(
      [0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653],
      var.log_retention_in_days
    )
    error_message = "log_retention_in_days must be one of the values CloudWatch Logs accepts: 0 (never expire), 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653."
  }
}

variable "tags" {
  description = "Tags applied to the gateway, stage and log group"
  type        = map(string)
  default     = {}
}
