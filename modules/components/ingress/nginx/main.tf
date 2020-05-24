resource "null_resource" "dependency_getter" {
  count = var.ingress_provider == "nginx" ? 1 : 0
  triggers = {
    instance = join(",", var.dependencies)
  }
}

resource "helm_release" "ingress-nginx" {
  count = var.ingress_provider == "nginx" ? 1 : 0
  name       = var.ingress_name
  chart      = "ingress-nginx"
  version    = var.ingress_helm_chart_version
  repository = "https://kubernetes.github.io/ingress-nginx"
  depends_on = [null_resource.dependency_getter]
  namespace = "ingress"
  create_namespace = true
  force_update = true

  values = []

  set {
      name = "replicas"
      value = var.ingress_num_replicas
  }

  set {
      name = "controller.autoscaling.enabled"
      value = var.ingress_autoscaling_enabled
  }

  set {
    name = "controller.useComponentLabel"
    value = var.ingress_controller_use_component_labels
  }

  set {
    name = "controller.metrics.serviceMonitor.enabled"
    value = var.ingress_controller_metrics_service_monitor_enabled
  }

  set {
      name = "metrics.enabled"
      value = var.ingress_metrics_enabled
  }

  set {
    name = "controller.metrics.prometheusRule.enabled"
    value = var.ingress_controller_metrics_prometheusRule_enabled
  }

  set {
    name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/${var.cloud_provider}-loadbalancer-hostname"
    value = var.cluster_dns_domain
  }

  set {
    name = "controller.resources.requests.cpu"
    value = "200m"
  }

  set {
    name = "controller.resources.limits.cpu"
    value = "400m"
  }

  set {
    name = "controller.resources.requests.memory"
    value = "128m"
  }

  set {
    name = "controller.resources.limits.memory"
    value = "512m"
  }

  set {
    name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/${var.cloud_provider}-loadbalancer-name"
    value = "${var.cluster_name}-loadbalancer"
  }

  # Disabled for now due to a terraform helm provider bug
  # See: https://github.com/terraform-providers/terraform-provider-helm/issues/475
  # set {
  #   name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/${var.cloud_provider}-loadbalancer-enable-proxy-protocol"
  #   value = var.ingress_enable_proxy_protocol
  # }

  # Disabled for now due to a terraform helm provider bug
  # See: https://github.com/terraform-providers/terraform-provider-helm/issues/475
  # set {
  #   name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/${var.cloud_provider}-loadbalancer-enable-backend-keepalive"
  #   value = var.ingress_enable_backend_keepalive
  # }

}