
variable "deployment_name" {
    default = "mattermost-central-command-control"
    type = "string"
}

variable "region" {
    default = "us-east-1"
    type = "string"
}

variable "tiller_version" {
    default = "2.14.1"
    type = "string"
}

variable "kubeconfig_dir" {
    default = "$HOME/generated"
    type = "string"
}

variable "grafana_tls_crt"{
    default = ""
    type = "string"
}

variable "grafana_tls_key"{
    default = ""
    type = "string"
}

variable "prometheus_tls_crt"{
    default = ""
    type = "string"
}

variable "prometheus_tls_key"{
    default = ""
    type = "string"
}

variable "kibana_tls_crt"{
    default = ""
    type = "string"
}

variable "kibana_tls_key"{
    default = ""
    type = "string"
}
