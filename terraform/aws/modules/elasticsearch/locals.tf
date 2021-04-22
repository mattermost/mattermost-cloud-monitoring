locals {
  thresholds = {
    FreeStorageSpaceThreshold        = max(var.free_storage_space_threshold, 0)
    MinimumAvailableNodes            = max(var.min_available_nodes, 0)
    CPUUtilizationThreshold          = min(max(var.cpu_utilization_threshold, 0), 100)
    JVMMemoryPressureThreshold       = min(max(var.jvm_memory_pressure_threshold, 0), 100)
    MasterCPUUtilizationThreshold    = min(max(coalesce(var.master_cpu_utilization_threshold, var.cpu_utilization_threshold), 0), 100)
    MasterJVMMemoryPressureThreshold = min(max(coalesce(var.master_jvm_memory_pressure_threshold, var.jvm_memory_pressure_threshold), 0), 100)
  }
  aws_sns_topic_arn = ["arn:aws:sns:us-east-1:${data.aws_caller_identity.current.account_id}:elb-alarm-topic"]
}
