
variable "region" {
    default = "us-east-1"
    type = "string"
}

variable "environment" {
    default = "dev"
    type = "string"
}

variable "vpc_ids" {
    default = [""]
    type = "list"
}
