variable "environment" {
  type        = string
  description = "The name of the environment which will deploy to and will be added as a tag"
}

variable "open_oidc_provider_url" {
  type        = string
  description = "The Open OIDC Provider URL for a specific cluster"
}

variable "open_oidc_provider_arn" {
  type        = string
  description = "The Open OIDC Provider ARN for a specific cluster"
}

variable "serviceaccount" {
  type        = string
  description = "Service Account, with which we want to associate IAM permission"
}

variable "namespace" {
  type        = string
  description = "The namespace, which host the service account & target application "
}

variable "applications" {
  description = "A map of application names to their keys and optional lengths"
  type = map(object({
    keys = list(object({
      name   = string
      length = optional(number, 16)
    }))
  }))
  default = {
    #    app1 = {
    #      keys = [
    #        { name = "DATABASE", length = 20 },
    #        { name = "other_key", length = 12 } # Custom length per key
    #      ]
    #    },
    #    app2 = {
    #      keys = [
    #        { name = "API_KEY", length = 32 },
    #        { name = "API_SECRET" } # Uses default length
    #      ]
    #    }
  }
}

