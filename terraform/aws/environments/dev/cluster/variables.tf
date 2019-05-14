
variable "vpc_id" {
    default = ""
    type    = "string"

}

variable "subnet_ids" {
    default = ["", ""]
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
    default = "1"
    type = "string"
}

variable "min_size" {
    default = "1"
    type = "string"
}

variable "desired_capacity" {
    default = "1"
    type = "string"
}

variable "region" {
    default = "us-east-1"
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

variable "cidr_blocks" {
    default = [""]
    type = "list"
    description = "CIDR to allow inbound cluster access"
}