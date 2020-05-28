resource "digitalocean_kubernetes_cluster" "k8s" {
  count = var.cloud_provider == "do" ? 1 : 0
  # Set the name of your kubernetes cluster  
  name    = var.cluster_name
  # Set the location/region where your cluster should be provisioned
  # Grab the latest available options from `doctl kubernetes options regions`
  region  = var.location
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = var.kubernetes_version

  node_pool {
    # Set the name pool of your kubernetes node pool  
    name = var.default_node_pool_name

    # Grab the latest version slug from `doctl kubernetes options sizes`
    size = var.default_node_pool_vm_size

    # Set to the number of worker nodes you want running in your k8s cluster
    node_count = var.agent_count

    # Should autoscaling be enabled?
    auto_scale = var.enable_auto_scaling

    # Specify the number of min nodes in the autoscaler
    min_nodes = var.autoscale_min_count

    # Specify the number of max nodes in the autoscaler
    max_nodes = var.autoscale_max_count

    # Tags to create when provisioning the k8s cluster
    tags = [var.environment, var.operator]
  }
}

module "flavorize" {
    source = "../../modules/components"
    prometheus_enabled = var.prometheus_enabled
    prometheus_chart_version = var.prometheus_chart_version
    prometheus_chart_custom_values = var.prometheus_chart_custom_values
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
    ingress_provider = var.ingress_provider
    externaldns_domains = var.externaldns_domains
    externaldns_api_token = var.externaldns_api_token
    externaldns_provider = var.externaldns_provider
    externaldns_helm_chart_version = var.externaldns_helm_chart_version
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
      token = digitalocean_kubernetes_cluster.k8s[0].kube_config.0.token
      host = digitalocean_kubernetes_cluster.k8s[0].kube_config.0.host
      client_certificate = digitalocean_kubernetes_cluster.k8s[0].kube_config.0.client_certificate
      client_key = digitalocean_kubernetes_cluster.k8s[0].kube_config.0.client_key
      cluster_ca_certificate = digitalocean_kubernetes_cluster.k8s[0].kube_config.0.cluster_ca_certificate
      kube_config = digitalocean_kubernetes_cluster.k8s[0].kube_config.0.raw_config
    }
    dependencies = [digitalocean_kubernetes_cluster.k8s[0].id]
}