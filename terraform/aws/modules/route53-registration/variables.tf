variable "deployment_name" {
  type        = string
  description = "EKS Cluster deployment name"
}

variable "private_hosted_zoneid" {
  type        = string
  description = "The AWS private hosted zone ID"
}

variable "public_hosted_zoneid" {
  type        = string
  description = "The AWS public hosted zone ID"
}

variable "cloudflare_zone_id" {
  type        = string
  description = "The Cloudflare zone ID provided"
}

variable "enable_portal_public_r53_record" {
  type        = bool
  description = "Enables to create a public route53 record for public Customer Web Server"
}

variable "enabled_cloudflare_customer_web_server" {
  type        = bool
  description = "Enables cloudflare for Customer Web Server"
}

variable "cloudflare_customer_webserver_cdn" {
  type        = string
  description = "The cloudflare CDN to proxy"
}

variable "enable_portal_private_r53_record" {
  type        = bool
  description = "Enables to create a private CNAME route53 record for Private Customer Web Server"
}

variable "enable_portal_internal_r53_record" {
  type        = bool
  description = "Enables to create a internal CNAME route53 record for Internal Customer Web Serve API"
}

variable "enable_awat_record" {
  type        = bool
  description = "Enables to create a private route53 record for private AWAT"
}

variable "enable_chimera_record" {
  type        = bool
  description = "Enables to create a public route53 record for private Chimera"
}

variable "enable_chaos_record" {
  type        = bool
  description = "Enables to create a private route53 record for private ChaosMesh"
}

variable "enable_kubecost_record" {
  type        = bool
  description = "Enables to create a public route53 record for private Kubecost"
}
