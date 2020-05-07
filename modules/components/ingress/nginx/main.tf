data "helm_repository" "ingress-nginx" {
  count = var.ingress_provider == "nginx" ? 1 : 0
  name = "ingress-nginx"
  url  = "https://kubernetes.github.io/ingress-nginx"
}

resource "null_resource" "dependency_getter" {
  count = var.ingress_provider == "nginx" ? 1 : 0
  triggers = {
    instance = join(",", var.dependencies)
  }
}

resource "kubernetes_namespace" "ingress" {
  count = var.ingress_provider == "nginx" ? 1 : 0
  depends_on = [null_resource.dependency_getter]
  metadata {
    annotations = {
      name = "ingress"
    }
    name = "ingress"
  }
}

resource "helm_release" "ingress-nginx" {
  count = var.ingress_provider == "nginx" ? 1 : 0
  name       = "ingress-nginx"
  chart      = "ingress-nginx"
  version    = var.ingress_helm_chart_version
  repository = data.helm_repository.ingress-nginx[0].metadata[0].name
  depends_on = [kubernetes_namespace.ingress]
  namespace = "ingress"

  values = []

  set {
      name = "replicas"
      value = "3"
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