variable "monitoring_namespace" {
  type        = string
  description = "The prometheus monitoring namespace which will be used in blackbox configuration"
}

variable "blackbox_target_discovery_cronjob_schedule" {
  type        = string
  description = "The schedule for the Kubernetes cron job"
}

variable "cloud_blackbox_target_discovery_image" {
  type        = string
  description = "The image of the container for blackbox"
}

variable "private_hosted_zone_id" {
  type        = string
  description = "The ID of the private Hosted zone"
}

variable "public_hosted_zone_id" {
  type        = string
  description = "The ID of the public Hosted zone"
}

variable "excluded_targets" {
  type        = string
  description = "The excluded targets in a comma separated manner for DNS"
}

variable "additional_targets" {
  type        = string
  description = "The addiational targets in a comma separated manner for DNS"
}

variable "prometheus_secret_name" {
  type        = string
  description = "The secret name that will be created to store the scrape config with the Blackbox targets. The same name should be used in the Prometheus Operator chart values"
}

variable "mattermost_alerts_hook" {
  type        = string
  description = "The URL alert hook where we can send notifications"
}

variable "bind_servers" {
  type        = string
  description = "The comma separated of IPs eg. 10.0.1.0:9153,10.0.2.0:9153"
}
