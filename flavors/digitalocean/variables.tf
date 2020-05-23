variable cloud_provider {
    default = "do"
}

variable "do_token" {
    default = ""
}

variable cluster_name {
    default = "k8s"
}

variable location {
    default = "nyc3"
}

variable kubernetes_version {
    default = "1.17.5-do.0"
}

variable default_node_pool_vm_size {
    default = "s-2vcpu-2gb"
}

variable default_node_pool_name {
    default = "agentpool"
}

variable agent_count {
    default = "1"
}

variable enable_auto_scaling {
    default = true
}

variable autoscale_min_count {
    default = 1
}

variable autoscale_max_count {
    default = 3
}

variable environment {
  default = "Devlab"
}

variable operator {
  default = "DevOps"
}