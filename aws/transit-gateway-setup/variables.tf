variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "ram_name" {
  description = "The name of the resource share of TGW"
  type        = string
  default     = ""
}
variable "ram_allow_external_principals" {
  description = "Indicates whether principals outside your organization can be associated with a resource share."
  type        = bool
  default     = true
}
variable "ram_tags" {
  description = "Additional tags for the RAM"
  type        = map(string)
  default     = {}
}
variable "tags" {
  description = "Additional tags for the RAM"
  type        = map(string)
  default     = {}
}
variable "amazon_side_asn" {
  description = "The Autonomous System Number (ASN) for the Amazon side of the gateway. By default the TGW is created with the current default Amazon ASN."
  type        = string
  default     = "64512"
}

variable "enable_auto_accept_shared_attachments" {
  description = "Whether resource attachment requests are automatically accepted"
  type        = string
  default     = "enable"
}

variable "enable_default_route_table_association" {
  description = "Whether resource attachments are automatically associated with the default association route table"
  type        = string
  default     = "enable"
}

variable "description" {
  description = "Description of the EC2 Transit Gateway"
  type        = string
  default     = null
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the TGW"
  type        = string
  default     = "enable"
}

variable "enable_default_route_table_propagation" {
  description = "Whether resource attachments automatically propagate routes to the default propagation route table"
  type        = string
  default     = "enable"
}

variable "ram_principals" {
  description = "A list of principals to share TGW with. Possible values are an AWS account ID, an AWS Organizations Organization ARN, or an AWS Organizations Organization Unit ARN"
  type        = list(string)
  default     = []
}

variable "security_destination_cidr_block" {
  type        = string
  description = "Value of the cidr block for the security TGW"
}

variable "cloud_destination_cidr_block" {
  type        = string
  description = "Value of the cidr block for the cloud core TGW"
}

variable "tgw_attachment_vpc_id" {
  type        = string
  description = "The VPC in the cross region we want to attach to the TGW"
}

variable "tgw_attachment_subnet_ids" {
  type        = list(string)
  default     = [""]
  description = "The Subnet IDs in the prod us-west-2 region we want to attach to the TGW"
}

variable "tgw_peering_attachment_name" {
  type        = string
  description = "The name of the peering attachment"
}

variable "peer_account_id" {
  type        = string
  description = "The account ID of the peer account"
}

variable "peer_region" {
  type        = string
  description = "The region we want to peer with (us-east-1)"
}

variable "peer_transit_gateway_id" {
  type        = string
  description = "The ID for the TGW in us-east-1 that we want to peer with"
}

variable "security_group_referencing_support" {
  description = "Security Group Referencing allows to specify other SGs as references, or matching criterion in inbound security rules to allow instance-to-instance traffic"
  type        = string
  default     = "enable"
}
