module "prometheus" {
    source = "../../modules/components/prometheus"
    prometheus_enabled = var.prometheus_enabled
    prometheus_chart_version = var.prometheus_chart_version
    dependencies = var.dependencies
}

module "nfs" {
    source = "../../modules/components/nfs"
    nfs_server_enabled = var.nfs_server_enabled
    nfs_chart_version = var.nfs_chart_version
    nfs_storage_class = var.nfs_storage_class
    nfs_persistence_enabled = var.nfs_persistence_enabled
    nfs_disk_size = var.nfs_disk_size
    dependencies = var.dependencies
}

module "rook" {
    source = "../../modules/components/rook"
    rook_enabled = var.rook_enabled
    rbac_enabled = var.rbac_enabled
    rook_helm_chart_version = var.rook_helm_chart_version
    dependencies = var.dependencies
}

module "certmanager-cloudflare" {
    source = "../../modules/components/certmanager/cloudflare"
    certmanager_provider = var.certmanager_provider
    certmanager_helm_chart_version = var.certmanager_helm_chart_version
    certmanager_email = var.certmanager_email
    certmanager_solver = var.certmanager_solver
    ingress_class = var.ingress_provider
    externaldns_domains = var.externaldns_domains
    externaldns_api_token = var.externaldns_api_token
    dependencies = var.dependencies
    kube_config = var.k8s.kube_config
}

module "externaldns-cloudflare" {
    source = "../../modules/components/externaldns/cloudflare"
    externaldns_provider = var.externaldns_provider
    externaldns_helm_chart_version = var.externaldns_helm_chart_version
    externaldns_domains = var.externaldns_domains
    externaldns_api_token = var.externaldns_api_token
    dependencies = var.dependencies
}

module "ingress-nginx" {
    source = "../../modules/components/ingress/nginx"
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
    dependencies = var.dependencies
}