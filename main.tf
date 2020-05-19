terraform {
    backend "local" {
    path = ".terraform/state/terraform.tfstate"
  }
}

// Uncomment this module if you want to use Azure AKS
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

// Uncomment this module if you want to use Digital Ocean k8s
// module "k8s" {
//     source = "./modules/k8s/digitalocean"
//     cloud_provider = var.cloud_provider
//     cluster_name = var.cluster_name
//     location = var.location
//     kubernetes_version = var.kubernetes_version
//     default_node_pool_vm_size = var.default_node_pool_vm_size
//     default_node_pool_name = var.default_node_pool_name
//     agent_count = var.agent_count
//     enable_auto_scaling = var.enable_auto_scaling
//     autoscale_min_count = var.autoscale_min_count
//     autoscale_max_count = var.autoscale_max_count
//     environment = var.environment
//     operator = var.operator
// }

module "prometheus" {
    source = "./modules/components/prometheus"
    prometheus_enabled = var.prometheus_enabled
    prometheus_chart_version = var.prometheus_chart_version
    dependencies = [module.k8s.id]
}

module "nfs" {
    source = "./modules/components/nfs"
    nfs_server_enabled = var.nfs_server_enabled
    nfs_chart_version = var.nfs_chart_version
    nfs_storage_class = var.nfs_storage_class
    nfs_persistence_enabled = var.nfs_persistence_enabled
    nfs_disk_size = var.nfs_disk_size
    dependencies = [module.k8s.id]
}

module "rook" {
    source = "./modules/components/rook"
    rook_enabled = var.rook_enabled
    rbac_enabled = var.rbac_enabled
    rook_helm_chart_version = var.rook_helm_chart_version
    dependencies = [module.k8s.id]
}

module "certmanager-cloudflare" {
    source = "./modules/components/certmanager/cloudflare"
    certmanager_provider = var.certmanager_provider
    certmanager_helm_chart_version = var.certmanager_helm_chart_version
    certmanager_email = var.certmanager_email
    certmanager_solver = var.certmanager_solver
    ingress_class = var.ingress_provider
    dns_domains = var.dns_domains
    dns_api_key = var.dns_api_key
    dependencies = [module.k8s.id]
    kube_config = module.k8s.kube_config
}

module "externaldns-cloudflare" {
    source = "./modules/components/externaldns/cloudflare"
    externaldns_provider = var.externaldns_provider
    externaldns_helm_chart_version = var.externaldns_helm_chart_version
    dns_domains = var.dns_domains
    dns_api_key = var.dns_api_key
    dns_api_email = var.dns_api_email
    dependencies = [module.k8s.id]
}

module "ingress-nginx" {
    source = "./modules/components/ingress/nginx"
    ingress_provider = var.ingress_provider
    ingress_name = var.ingress_name
    ingress_helm_chart_version = var.ingress_helm_chart_version
    dependencies = [module.k8s.id]
}

output "client_key" {
    value = module.k8s.client_key
}

output "client_certificate" {
    value = module.k8s.client_certificate
}

output "cluster_ca_certificate" {
    value = module.k8s.cluster_ca_certificate
 }

output "kube_config" {
    value = module.k8s.kube_config
}

output "token" {
    value = module.k8s.token
}

output "host" {
    value = module.k8s.host
}

output "cloud_provider" {
    value = var.cloud_provider
}