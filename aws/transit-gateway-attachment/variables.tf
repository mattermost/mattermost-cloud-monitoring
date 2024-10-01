variable "subnet_ids" {
  description = "Identifiers of EC2 Subnets"
  type        = list(string)
}
variable "transit_gateway_id" {
  description = "Identifier of EC2 Transit Gateway"
  type        = string
}
variable "vpc_id" {
  description = "Identifier of EC2 VPC"
  type        = string
}
variable "name" {
  description = "The name tag of the tgw attachment"
  type        = string
}

variable "security_group_referencing_support" {
  description = "Security Group Referencing allows to specify other SGs as references, or matching criterion in inbound security rules to allow instance-to-instance traffic"
  type        = string
  default     = "enable"
}
