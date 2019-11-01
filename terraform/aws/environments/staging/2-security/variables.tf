
variable "region" {
    default = "us-east-1"
    type = "string"
}

variable "environment" {
    default = "staging"
    type = "string"
}

variable "vpc_ids" {
    default = [""]
    type = list(string)
}
