variable ingress_provider {
    type = string
    default = "none"
}

variable cloud_provider {
    type = string
    default = "none"
}

variable "ingress_enable_proxy_protocol" {
    type = string
    default = "true"
}

variable "ingress_enable_backend_keepalive" {
    type = string
    default = "false"
}

variable cluster_name {
    type = string
    default = "k8s"
}

variable ingress_name {
    type = string
    default = "ingress-nginx"
}

variable cluster_dns_domain {
    default = ""
}

variable ingress_autoscaling_enabled {
    default = "false"
}

variable ingress_controller_use_component_labels {
    default = "true"
}

variable "ingress_metrics_enabled" {
  default = "true"
}

variable "ingress_controller_metrics_service_monitor_enabled" {
    default = "true"
}

variable "ingress_controller_metrics_prometheusRule_enabled" {
  default = "true"
}

variable "ingress_num_replicas" {
  default = "1"
}

variable ingress_helm_chart_version {
    type = string
    default = "2.1.0"
}

variable dependencies {
  description = "Create a dependency between the resources in this module to the interpolated values in this list (and thus the source resources). In other words, the resources in this module will now depend on the resources backing the values in this list such that those resources need to be created before the resources in this module, and the resources in this module need to be destroyed before the resources in the list."
  type        = list(string)
  default     = []
}