variable "priv_domain" {
  type        = string
  description = "The domain name for ACM certificate for a private zone"
}

variable "priv_validation_acm_zoneid" {
  type        = string
  description = "The Hosted Zone id of the desired Hosted Zone"
}

variable "priv_alternative_cert_domains" {
  type        = list(string)
  description = "The list of alternative cert domains for private ACM certificate"
}

variable "private_tags" {
  type        = map(string)
  description = "The tags which will attached in the private ACM certificate"
}

variable "pub_domain" {
  type        = string
  description = "The domain name for ACM certificate for a public zone"
}

variable "public_tags" {
  type        = map(string)
  description = "The tags which will attached in the public ACM certificate"
}

variable "pub_validation_acm_zoneid" {
  type        = string
  description = "The Hosted Zone id of the desired Hosted Zone for the public Route53 record"
}
