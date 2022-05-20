resource "cloudflare_load_balancer_monitor" "https_monitor" {
  type           = "https"
  expected_codes = var.expected_codes
  method         = var.monitor_method
  timeout        = var.timeout
  path           = "/"
  interval       = var.interval
  retries        = var.retries
  description    = var.name
  header {
    header = var.header
    values = var.header_value
  }
  allow_insecure   = false
  follow_redirects = var.follow_redirects
}

resource "cloudflare_load_balancer_pool" "lb-pool" {
  name               = var.name
  description        = var.description
  enabled            = var.pool_enable
  minimum_origins    = 1
  notification_email = var.notification_email
  origin_steering {
    policy = var.policy
  }
  monitor = cloudflare_load_balancer_monitor.https_monitor.id
  origins {
    name    = var.region_1
    address = var.region_1_address
    enabled = var.region_1_enable
    weight  = var.region_1_weight
  }
  origins {
    name    = var.region_2
    address = var.region_2_address
    enabled = var.region_2_enable
    weight  = var.region_2_weight
  }
}
