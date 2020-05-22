terraform {
    backend "local" {
    path = ".terraform/state/terraform.tfstate"
  }
}

## Start Of Azure (AKS) Kubernetes Configuration
## Comment this section if you are not provisioning Kubernetes (AKS) with Azure
module "k8s" {
    source = "./modules/k8s/azure"
    cloud_provider = var.cloud_provider
    arm_subscription_id = var.arm_subscription_id
    arm_client_id = var.arm_client_id
    arm_client_secret = var.arm_client_secret
    environment = var.environment
    operator = var.operator
    agent_count = var.agent_count
    autoscale_min_count = var.autoscale_min_count
    autoscale_max_count = var.autoscale_max_count
    enable_auto_scaling = var.enable_auto_scaling
    dns_prefix = var.dns_prefix
    cluster_name = var.cluster_name
    resource_group_name = var.resource_group_name
    location = var.location
    kubernetes_version = var.kubernetes_version
    node_disk_size = var.node_disk_size
    network_plugin = var.network_plugin
    network_policy = var.network_policy
    service_cidr = var.service_cidr
    dns_service_ip = var.dns_service_ip
    docker_bridge_cidr = var.docker_bridge_cidr
    load_balancer_sku = var.load_balancer_sku
    linux_profile_admin_username = var.linux_profile_admin_username
    ssh_key = var.ssh_key
    default_node_pool_name = var.default_node_pool_name
    default_node_pool_vm_size = var.default_node_pool_vm_size
    enable_kube_dashboard = var.enable_kube_dashboard
    availability_zones = var.availability_zones
}
## End Of Azure (AKS) Kubernetes Configuration

## Start Of Digital Ocean Kubernetes Configuration
## Comment this section if you are not provisioning kubernetes with Digital Ocean
#  module "k8s" {
#      source = "./modules/k8s/digitalocean"
#      cloud_provider = var.cloud_provider
#      cluster_name = var.cluster_name
#      location = var.location
#      kubernetes_version = var.kubernetes_version
#      default_node_pool_vm_size = var.default_node_pool_vm_size
#      default_node_pool_name = var.default_node_pool_name
#      agent_count = var.agent_count
#      enable_auto_scaling = var.enable_auto_scaling
#      autoscale_min_count = var.autoscale_min_count
#      autoscale_max_count = var.autoscale_max_count
#      environment = var.environment
#      operator = var.operator
# }
## End Of Digital Ocean Kubernetes Configuration