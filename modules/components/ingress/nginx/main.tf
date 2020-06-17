resource "null_resource" "dependency_getter" {
  count = var.ingress_nginx_enabled == "true" ? 1 : 0
  triggers = {
    instance = join(",", var.dependencies)
  }
}

resource "helm_release" "ingress-nginx" {
  count = var.ingress_nginx_enabled == "true" ? 1 : 0
  name       = var.name
  chart      = "ingress-nginx"
  version    = var.ingress_nginx_helm_chart_version
  repository = var.repository
  depends_on = [null_resource.dependency_getter]
  namespace = var.namespace
  create_namespace = var.create_namespace
  force_update = var.force_update

  values = fileexists(var.ingress_nginx_chart_custom_values) ? [ file(var.ingress_nginx_chart_custom_values) ] : []

}