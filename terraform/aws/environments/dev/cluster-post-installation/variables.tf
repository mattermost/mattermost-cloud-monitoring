
variable "deployment_name" {
    default = "mattermost-central-monitoring-cluster"
    type = "string"
}

variable "account_id" {
    default = ""
    type    = "string"
}

variable "region" {
    default = "us-east-1"
    type = "string"
}

variable "tiller_version" {
    default = "2.13.1"
    type = "string"
}

variable "grafana_version" {
    default = ""
    type = "string"
}

variable "kubeconfig_dir" {
    default = "$HOME/generated"
    type = "string"
}
