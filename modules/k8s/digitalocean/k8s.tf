resource "digitalocean_kubernetes_cluster" "k8s" {
  count = var.cloud_provider == "digitalocean" ? 1 : 0
  # Set the name of your kubernetes cluster  
  name    = var.cluster_name
  # Set the location/region where your cluster should be provisioned
  # Grab the latest available options from `doctl kubernetes options regions`
  region  = var.location
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = var.kubernetes_version

  node_pool {
    # Set the name pool of your kubernetes node pool  
    name       = var.default_node_pool_name

    # Grab the latest version slug from `doctl kubernetes options sizes`
    size       = var.default_node_pool_vm_size

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