variable "deployment_name" {
    default = "mattermost-central-command-control"
    type = "string"
}
variable "region" {
    default = "us-east-1"
    type = "string"
}

variable "kubeconfig_dir" {
    default = "$HOME/generated"
    type = "string"
}

variable "public_hosted_zoneid" {
    default = ""
    type = "string"
}

variable "private_hosted_zoneid" {
    default = ""
    type = "string"
}
