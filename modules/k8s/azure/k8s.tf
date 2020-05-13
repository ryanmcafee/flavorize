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