data "helm_repository" "rook-release" {
  count = var.rook_enabled == "true" ? 1 : 0
  name = "rook-release"
  url  = "https://charts.rook.io/release"
}

resource "null_resource" "dependency_getter" {
  count = var.rook_enabled == "true" ? 1 : 0
  triggers = {
    instance = join(",", var.dependencies)
  }
}

resource "kubernetes_namespace" "rook-ceph" {
  count = var.rook_enabled == "true" ? 1 : 0
  depends_on = [null_resource.dependency_getter]
  metadata {
    annotations = {
      name = "rook-ceph"
    }
    name = "rook-ceph"
  }
}

resource "helm_release" "rook-ceph" {
  count = var.rook_enabled == "true" ? 1 : 0
  name       = "rook-ceph"
  chart      = "rook-ceph"
  version    = var.rook_helm_chart_version
  repository = data.helm_repository.rook-release[0].metadata[0].name
  depends_on = [kubernetes_namespace.rook-ceph]
  namespace = kubernetes_namespace.rook-ceph[0].metadata[0].name

  values = []

  set {
      name = "rbacEnable"
      value = var.rbac_enabled
  }

  set {
    name = "csi.enableGrpcMetrics"
    value = false
  }

}