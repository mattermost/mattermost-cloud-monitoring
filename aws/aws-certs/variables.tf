variable "validation_acm_zoneid" {
  type        = string
  description = "The Hosted Zone ID for certs validation"
}

variable "priv_domain" {
  type        = string
  description = "The domain name for ACM certificate for a private zone"
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
  description = "The desired Hosted Zone ID for the public zone"
}

variable "alternative_cert_domains" {
  type        = string
  description = "The alternative cert domains to be added"
}
