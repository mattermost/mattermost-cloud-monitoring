module "cloudflare_load_balancer_pool" {
  source      = "git::https://github.com/mattermost/mattermost-cloud-monitoring.git//aws/cloudflare-lb-pools=v1.0.0"
  name        = "test-pool"
  description = "Test TF Community Pool to support HA"
  pool_enable = true
  header = "Host"
  header_value = ["community-dr.staging.xxxx.com"]
  expected_codes="200"
  monitor_method="GET"
  follow_redirects=true
  interval=60
  timeout=7
  retries= 3
# minimum_origins = 1
  notification_email = "someone@example.com"
  policy = "random"
  region_1 = "us-east-1"
# Address should be reachable for monitor to work
  region_1_address = "192.2.1.1" 
  region_1_enable = false
  region_1_weight  = 0
  region_2 = "us-west-2"
# Address should be reachable for monitor to work
  region_2_address = "192.2.1.2"
  region_2_enable = true
  region_2_weight  = 1
# Load balancer configuration
  zone_id          = "1234567dcfr99999"
  lb_name             = "test-ha-lb.domain.com"
  proxied          = true
  steering_policy  = "off"
}
