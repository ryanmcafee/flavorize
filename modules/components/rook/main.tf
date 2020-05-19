resource "null_resource" "dependency_getter" {
  count = var.rook_enabled == "true" ? 1 : 0
  triggers = {
    instance = join(",", var.dependencies)
  }
}

resource "helm_release" "rook-ceph" {
  count = var.rook_enabled == "true" ? 1 : 0
  name       = "rook-ceph"
  chart      = "rook-ceph"
  version    = var.rook_helm_chart_version
  repository = "https://charts.rook.io/release"
  depends_on = [null_resource.dependency_getter]
  namespace = "rook-ceph"
  create_namespace = true
  force_update = true

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