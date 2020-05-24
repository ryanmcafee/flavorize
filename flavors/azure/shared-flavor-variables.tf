variable k8s {
    type = map
    default = {
        load_config_file = "false"
        kube_config = ""
        token = ""
        host = ""
        client_certificate = ""
        client_key = ""
        cluster_ca_certificate = ""
    }
}

variable dependencies {
  description = "Create a dependency between the resources in this module to the interpolated values in this list (and thus the source resources). In other words, the resources in this module will now depend on the resources backing the values in this list such that those resources need to be created before the resources in this module, and the resources in this module need to be destroyed before the resources in the list."
  type        = list(string)
  default     = []
}

variable kube_config {
    type = string
    default = ""
}

# Ingress Settings
variable ingress_provider {
    type = string
    default = "none"
}

variable ingress_helm_chart_version {
    type = string
    default = "2.3.0"
}

variable ingress_enable_proxy_protocol {
    type = string
    default = "true"
}

variable ingress_enable_backend_keepalive {
    type = string
    default = "false"
}

variable cluster_dns_domain {
    default = ""
}

variable ingress_name {
    type = string
    default = "ingress-nginx"
}

variable ingress_service_annotations {
    default = {}
}

variable ingress_autoscaling_enabled {
    type = string
    default = "false"
}

variable ingress_controller_autoscaling_target_cpu_utilization_percentage {
  type = string
  default = 50
}

variable ingress_controller_autoscaling_target_memory_utilization_percentage {
  type = string
  default = 50
}

variable ingress_controller_use_component_labels {
    type = string
    default = "true"
}

variable ingress_metrics_enabled {
    type = string
    default = "true"
}

variable ingress_controller_metrics_service_monitor_enabled {
    type = string
    default = "true"
}

variable ingress_controller_metrics_prometheusRule_enabled {
    type = string
    default = "true"
}

variable ingress_num_replicas {
    type = string
    default = "1"
}

# External DNS Settings
variable externaldns_provider {
    type = string
    default = "none"
}

variable externaldns_helm_chart_version {
    type = string
    default = "2.22.1"
}

variable externaldns_domains {
    type = string
    default = ""
}

variable externaldns_api_token {
    type = string
    default = ""
}

# Cert Manager Settings
variable certmanager_provider {
    type = string
    default = "none"
}

variable certmanager_solver {
    type = string
    default = "HTTP01"
}

variable certmanager_email {
    type = string
    default = "example@example.com"
}

variable certmanager_helm_chart_version {
    default = "0.15.0"
}

# Rook Settings
variable rook_enabled {
    type = string
    default = "false"
}

variable rook_helm_chart_version {
    type = string
    default = "v1.3.3"
}

variable rbac_enabled {
    type = string
    default = "true"
}

# NFS Settings
variable nfs_server_enabled {
    type = string
    default = "false"
}

variable nfs_chart_version {
    type = string
    default = "1.0.0"
}

variable nfs_storage_class {
    type = string
    default = ""
}

variable nfs_persistence_enabled {
    type = string
    default = "true"
}

variable nfs_disk_size {
    type = string
    default = "50Gi"
}

# Prometheus related settings
variable prometheus_enabled {
    type = string
    default = "false"
}

variable prometheus_chart_version {
  type = string
  default = "8.13.8"
}

