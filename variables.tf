variable arm_subscription_id {}

variable arm_client_id {}

variable arm_client_secret {}

variable cloud_provider {}

variable environment {
  default = "Devlab"
}

variable operator {
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
    default = "k8s"
}

variable cluster_name {
    default = "k8s"
}

variable resource_group_name {
    default = "azure-k8s"
}

variable location {
    default = "East US"
}

variable kubernetes_version {
    default = "1.16.7"
}

variable node_disk_size {
    default = 40
}

variable network_plugin {
    default = "azure"
}

variable network_policy {
    default = "calico"
}

variable service_cidr {
    default = "172.100.0.0/24"
}

variable dns_service_ip {
    default = "172.100.0.10"
}

variable docker_bridge_cidr {
    default = "172.101.0.1/16"
}

variable load_balancer_sku {
    default = "Standard"
}

variable linux_profile_admin_username {
    default = "ubuntu"
}

variable ssh_public_key {
    default = "~/.ssh/id_rsa.pub"
}

variable default_node_pool_name {
    default = "agentpool"
}

variable default_node_pool_vm_size {
    default = "Standard_B4ms"
}

variable enable_kube_dashboard {
    default = true
}

variable availability_zones {
    default = ["1", "2", "3"]
}

variable ingress_provider {
    type = string
    default = "none"
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

variable dns_domains {}

variable dns_api_token {}

variable dns_api_key {}

variable dns_api_email {}

variable certmanager_provider {
    type = string
    default = "none"
}

variable certmanager_helm_chart_version {
    default = "0.15.0"
}

