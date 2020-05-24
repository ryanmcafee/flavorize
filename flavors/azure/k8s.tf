resource "azurerm_resource_group" "k8s" {
    count = var.cloud_provider == "azure" ? 1 : 0
    name = var.resource_group_name
    location = var.location
}

resource "azurerm_kubernetes_cluster" "k8s" {
    count = var.cloud_provider == "azure" ? 1 : 0
    name                = var.cluster_name
    resource_group_name = azurerm_resource_group.k8s[0].name
    location            = azurerm_resource_group.k8s[0].location
    dns_prefix          = var.dns_prefix
    kubernetes_version = var.kubernetes_version

    network_profile {
        network_plugin = var.network_plugin
        network_policy = var.network_policy
        service_cidr = var.service_cidr
        dns_service_ip = var.dns_service_ip
        docker_bridge_cidr = var.docker_bridge_cidr
        load_balancer_sku = var.load_balancer_sku
        outbound_type = "loadBalancer"

        load_balancer_profile {
            managed_outbound_ip_count = 1
        }
    }

    linux_profile {
        admin_username = var.linux_profile_admin_username

        ssh_key {
            key_data = file(var.ssh_key)
        }
    }

    default_node_pool {
        name            = var.default_node_pool_name
        vm_size         = var.default_node_pool_vm_size
        os_disk_size_gb = var.node_disk_size
        availability_zones = var.availability_zones
        node_count      = var.agent_count
        min_count = var.autoscale_min_count
        max_count = var.autoscale_max_count
        enable_auto_scaling = var.enable_auto_scaling
    }

    service_principal {
        client_id     = var.arm_client_id
        client_secret = var.arm_client_secret
    }

    addon_profile {
        kube_dashboard {
            enabled = var.enable_kube_dashboard
        }
    }

    tags = {
        Environment = var.environment
        Operator = var.operator
    }

}

module "flavorize" {
    source = "../../modules/components"
    prometheus_enabled = var.prometheus_enabled
    prometheus_chart_version = var.prometheus_chart_version
    nfs_server_enabled = var.nfs_server_enabled
    nfs_chart_version = var.nfs_chart_version
    nfs_storage_class = var.nfs_storage_class
    nfs_persistence_enabled = var.nfs_persistence_enabled
    nfs_disk_size = var.nfs_disk_size
    rook_enabled = var.rook_enabled
    rbac_enabled = var.rbac_enabled
    rook_helm_chart_version = var.rook_helm_chart_version
    certmanager_provider = var.certmanager_provider
    certmanager_helm_chart_version = var.certmanager_helm_chart_version
    certmanager_email = var.certmanager_email
    certmanager_solver = var.certmanager_solver
    externaldns_domains = var.externaldns_domains
    externaldns_api_token = var.externaldns_api_token
    externaldns_provider = var.externaldns_provider
    externaldns_helm_chart_version = var.externaldns_helm_chart_version
    ingress_provider = var.ingress_provider
    cluster_name = var.cluster_name
    ingress_name = var.ingress_name
    ingress_enable_proxy_protocol = var.ingress_enable_proxy_protocol
    ingress_enable_backend_keepalive = var.ingress_enable_backend_keepalive
    cloud_provider = var.cloud_provider
    cluster_dns_domain = var.cluster_dns_domain
    ingress_helm_chart_version = var.ingress_helm_chart_version
    ingress_num_replicas = var.ingress_num_replicas
    ingress_autoscaling_enabled = var.ingress_autoscaling_enabled
    ingress_controller_use_component_labels = var.ingress_controller_use_component_labels
    ingress_controller_metrics_service_monitor_enabled = var.ingress_controller_metrics_service_monitor_enabled
    ingress_metrics_enabled = var.ingress_metrics_enabled
    ingress_controller_metrics_prometheusRule_enabled = var.ingress_controller_metrics_prometheusRule_enabled
    ingress_controller_autoscaling_target_cpu_utilization_percentage = var.ingress_controller_autoscaling_target_cpu_utilization_percentage
    ingress_controller_autoscaling_target_memory_utilization_percentage = var.ingress_controller_autoscaling_target_memory_utilization_percentage
    k8s = {
      load_config_file = false
      token = ""
      host = azurerm_kubernetes_cluster.k8s[0].kube_config.0.host
      client_certificate = azurerm_kubernetes_cluster.k8s[0].kube_config.0.client_certificate
      client_key = azurerm_kubernetes_cluster.k8s[0].kube_config.0.client_key
      cluster_ca_certificate = azurerm_kubernetes_cluster.k8s[0].kube_config.0.cluster_ca_certificate
      kube_config = azurerm_kubernetes_cluster.k8s[0].kube_config_raw
    }
    dependencies = [azurerm_kubernetes_cluster.k8s[0].id]
}