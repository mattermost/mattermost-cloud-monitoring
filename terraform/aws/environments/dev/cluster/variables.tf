variable "vpc_id" {
    default = ""
    type    = "string"

}

variable "public_subnet_ids" {
    default = [""]
    type = "list"
}

variable "private_subnet_ids" {
    default = [""]
    type = "list"
}

variable "deployment_name" {
    default = "mattermost-central-monitoring-cluster"
    type = "string"
}

variable "instance_type" {
    default = "t2.medium"
    type = "string"
}

variable "max_size" {
    default = "3"
    type = "string"
}

variable "min_size" {
    default = "1"
    type = "string"
}

variable "desired_capacity" {
    default = "3"
    type = "string"
}

variable "region" {
    default = "us-east-1"
    type = "string"
}

variable "account_id" {
    default = ""
    type = "string"
}

variable "environment" {
    default = "dev"
    type = "string"
}

variable "cidr_blocks" {
    default = [""]
    type = "list"
    description = "CIDR to allow inbound cluster access"
}

variable "kubeconfig_dir" {
    default = "$HOME/generated"
    type = "string"
}

variable "volume_size" {
    default = "50"
    type = "string"
}
