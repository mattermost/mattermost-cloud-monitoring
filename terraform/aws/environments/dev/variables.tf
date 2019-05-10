
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
