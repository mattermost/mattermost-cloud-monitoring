variable "node_group" {
  default = {
    "general" = {
      instance_type = "t3.large"
      max_size      = 5
      min_size      = 3
      desired_size  = 3
      enable_taint  = false
    }
    "general_cpu" = {
      instance_type = "c6i.xlarge"
      max_size      = 2
      min_size      = 1
      desired_size  = 1
      enable_taint  = true
      taints = {
        crossplane = {
          key    = "general_cpu"
          value  = "cpuGroup"
          effect = "PREFER_NO_SCHEDULE"
        }
      }
    }
  }
  type        = any
  description = "Worker node group"
}