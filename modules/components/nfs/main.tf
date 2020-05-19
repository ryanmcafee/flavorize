resource "null_resource" "dependency_getter" {
  count = var.nfs_server_enabled == "true" ? 1 : 0
  triggers = {
    instance = join(",", var.dependencies)
  }
}

resource "helm_release" "nfs" {
  count = var.nfs_server_enabled == "true" ? 1 : 0
  name       = "nfs"
  chart      = "nfs-server-provisioner"
  version    = var.nfs_chart_version
  repository = "https://kubernetes-charts.storage.googleapis.com"
  depends_on = [null_resource.dependency_getter]
  namespace = "nfs"
  create_namespace = true
  force_update = true
  
  values = []

  set {
      name = "persistence.storageClass"
      value = var.nfs_storage_class
  }

  set {
      name = "persistence.enabled"
      value = var.nfs_persistence_enabled
  }

  set {
      name = "persistence.size"
      value = var.nfs_disk_size
  }

  set {
      name = "storageClass.provisionerName"
      value = "nfs-server-provisioner"
  }

}