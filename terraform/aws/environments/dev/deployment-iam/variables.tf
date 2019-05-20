
variable "deployment_name" {
    default = "mattermost-central-monitoring-cluster"
    type = "string"
}

variable "account_id" {
    default = ""
    type    = "string"
}

variable "environment" {
    default = "dev"
    type = "string"
}
