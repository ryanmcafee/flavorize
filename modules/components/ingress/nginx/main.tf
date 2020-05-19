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
      value = "1"
  }

  set {
      name = "controller.autoscaling.enabled"
      value = true
  }

  set {
      name = "metrics.enabled"
      value = true
  }

}