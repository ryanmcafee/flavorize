resource "null_resource" "dependency_getter" {
  count = var.externaldns_enabled == "true" ? 1 : 0
  triggers = {
    instance = join(",", var.dependencies)
  }
}

resource "helm_release" "external-dns" {
  count = var.externaldns_enabled == "true" ? 1 : 0
  depends_on = [null_resource.dependency_getter]
  chart      = "external-dns"
  name       = var.name
  repository = var.repository
  version    = var.externaldns_helm_chart_version
  namespace = var.namespace
  create_namespace = var.create_namespace
  force_update = var.force_update
  
  values = fileexists(var.externaldns_chart_custom_values) ? [ file(var.externaldns_chart_custom_values) ] : []

}