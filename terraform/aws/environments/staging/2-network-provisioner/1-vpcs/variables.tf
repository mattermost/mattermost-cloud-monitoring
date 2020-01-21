variable "environment" {
    default = "staging"
    type = "string"
}

variable "region" {
    default = "us-east-1"
    type = "string"
}

variable "vpc_cidrs" {
    default = [""]
    type = list(string)
}

variable "vpc_azs" {
    default = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"]
    type = list(string)
}
