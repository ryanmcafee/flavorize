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
    default = 1
}

variable autoscale_max_count {
    default = 3
}

variable enable_auto_scaling {
    default = true
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

variable ingress_provider {
    type = string
    default = "none"
}

variable ingress_name {
    type = string
    default = "ingress-nginx"
}

variable ingress_helm_chart_version {
    type = string
    default = "2.1.0"
}

variable externaldns_provider {
    type = string
    default = "none"
}

variable externaldns_helm_chart_version {
    type = string
    default = "2.22.1"
}

variable dns_domains {
    type = string
    default = ""
}

variable dns_api_token {
    type = string
    default = ""
}

variable dns_api_key {
    type = string
    default = ""
}

variable dns_api_email {
    type = string
    default = ""
}

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
    default = ""
}

variable certmanager_helm_chart_version {
    default = "0.15.0"
}

