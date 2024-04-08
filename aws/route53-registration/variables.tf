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

variable "cws_cloudflare_record_name" {
  type        = string
  description = "The Cloudflare DNS record name for customer web server"
}

variable "enable_portal_public_r53_record" {
  default     = false
  type        = bool
  description = "Enables to create a public route53 record for public Customer Web Server"
}

variable "enabled_cloudflare_customer_web_server" {
  default     = false
  type        = bool
  description = "Enables cloudflare for Customer Web Server"
}

variable "cloudflare_customer_webserver_cdn" {
  type        = string
  description = "The cloudflare CDN to proxy"
}

variable "enable_portal_private_r53_record" {
  default     = false
  type        = bool
  description = "Enables to create a private CNAME route53 record for Private Customer Web Server"
}

variable "enable_portal_internal_r53_record" {
  default     = false
  type        = bool
  description = "Enables to create a internal CNAME route53 record for Internal Customer Web Serve API"
}

variable "enable_awat_record" {
  default     = false
  type        = bool
  description = "Enables to create a private route53 record for private AWAT"
}

variable "enable_chimera_record" {
  default     = false
  type        = bool
  description = "Enables to create a public route53 record for private Chimera"
}

variable "enable_chaos_record" {
  default     = false
  type        = bool
  description = "Enables to create a private route53 record for private ChaosMesh"
}

variable "enable_kubecost_record" {
  default     = false
  type        = bool
  description = "Enables to create a public route53 record for private Kubecost"
}

variable "enable_push_proxy_record" {
  default     = false
  type        = bool
  description = "Enables to create a private route53 record for Mattermost Push Proxy"
}

variable "enable_loki_gateway" {
  default     = false
  type        = bool
  description = "Enables to create a private route53 record for Loki Gateway"
}

variable "enable_loki_frontend" {
  default     = false
  type        = bool
  description = "Enables to create a private route53 record for Loki Frontend"
}

variable "enable_loki_developers_gateway" {
  default     = false
  type        = bool
  description = "Enables to create a private route53 record for Loki Developers Gateway"
}

variable "enable_loki_developers_frontend" {
  default     = false
  type        = bool
  description = "Enables to create a private route53 record for Loki Developers Frontend"
}

variable "enabled_cloudflare_chimera" {
  default     = true
  type        = bool
  description = "Enables cloudflare for Chimera"
}

variable "chimera_cloudflare_record_name" {
  default     = "chimera"
  type        = string
  description = "Cloudflare record name for Chimera"
}

variable "cloudflare_chimera_cdn" {
  default     = "chimera.test.cloud.mattermost.com.cdn.cloudflare.net"
  type        = string
  description = "CDN name for Chimera"
}

variable "enable_elrond_private_r53_record" {
  default     = false
  type        = bool
  description = "Enables to create a private CNAME route53 record for Elrond."
}

variable "enable_alertmanager_r53_record" {
  default     = false
  type        = bool
  description = "Enable to create a private CNAME route53 record for Alertmanager."
}

variable "kubernetes_service_nginx_public" {
  default     = "nginx-ingress-nginx-controller"
  type        = string
  description = "Name of nginx public service of CnC cluster"
}

variable "kubernetes_service_nginx_private" {
  default     = "nginx-internal-ingress-nginx-controller"
  type        = string
  description = "Name of nginx private service of CnC cluster"
}
