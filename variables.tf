variable arm_tenant_id {
    type = string
    default = ""
}

variable arm_subscription_id {
    type = string
    default = ""
}

variable arm_client_id {
    type = string
    default = ""
}

variable arm_client_secret {
    type = string
    default = ""
}

variable cloud_provider {
    type = string
    default = "none"
}

variable environment {
    type = string
    default = "dev"
}

variable operator {
    type = string
    default = "DevOps"
}

variable agent_count {
    default = 1
}

variable autoscale_min_count {
    default = null
}

variable autoscale_max_count {
    default = null
}

variable enable_auto_scaling {
    default = false
}

variable dns_prefix {
    type = string
    default = "k8s"
}

variable cluster_name {
    type = string
    default = "k8s"
}

variable resource_group_name {
    type = string
    default = "azure-k8s"
}

variable location {
    type = string
    default = "East US"
}

variable kubernetes_version {
    type = string
    default = "1.16.7"
}

variable node_disk_size {
    type = string
    default = 40
}

variable network_plugin {
    type = string
    default = "azure"
}

variable network_policy {
    type = string
    default = "calico"
}

variable service_cidr {
    type = string
    default = "172.100.0.0/24"
}

variable dns_service_ip {
    type = string
    default = "172.100.0.10"
}

variable docker_bridge_cidr {
    type = string
    default = "172.101.0.1/16"
}

variable load_balancer_sku {
    type = string
    default = "Standard"
}

variable linux_profile_admin_username {
    type = string
    default = "ubuntu"
}

variable ssh_key {
    type = string
    default = "credentials/ssh/id_rsa.pub"
}

variable default_node_pool_name {
    type = string
    default = "agentpool"
}

variable default_node_pool_vm_size {
    type = string
    default = "Standard_B4ms"
}

variable enable_kube_dashboard {
    type = string
    default = true
}

variable availability_zones {
    default = ["1", "2", "3"]
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

variable "ingress_enable_proxy_protocol" {
    type = string
    default = "true"
}

variable "ingress_enable_backend_keepalive" {
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

variable ingress_controller_use_component_labels {
    type = string
    default = "true"
}

variable "ingress_metrics_enabled" {
    type = string
    default = "true"
}

variable "ingress_controller_metrics_service_monitor_enabled" {
    type = string
    default = "true"
}

variable "ingress_controller_metrics_prometheusRule_enabled" {
    type = string
    default = "true"
}

variable "ingress_num_replicas" {
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

