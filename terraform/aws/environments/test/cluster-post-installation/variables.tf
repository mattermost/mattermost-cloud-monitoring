
variable "deployment_name" {
    default = "mattermost-central-command-control"
    type = "string"
}

variable "region" {
    default = "us-east-1"
    type = "string"
}

variable "tiller_version" {
    default = "2.13.1"
    type = "string"
}

variable "kubeconfig_dir" {
    default = "$HOME/generated"
    type = "string"
}
