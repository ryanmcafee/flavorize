resource "null_resource" "dependency_getter" {
  count = var.prometheus_enabled == "true" ? 1 : 0
  triggers = {
    instance = join(",", var.dependencies)
  }
}

resource "helm_release" "prometheus" {
  count = var.prometheus_enabled == "true" ? 1 : 0
  name       = "prometheus"
  chart      = "prometheus-operator"
  version    = var.prometheus_chart_version
  repository = "https://kubernetes-charts.storage.googleapis.com"
  depends_on = [null_resource.dependency_getter]
  namespace = "monitoring"
  create_namespace = true
  force_update = true

  # Fetch latest from https://github.com/helm/charts/blob/master/stable/prometheus/values.yaml and modify for your purposes.
  # File should be stored in customizations/helm/prometheus/values.yaml. This file is not tracked in git to allow more advanced customizations.
  # Apply helm prometheus configuration specific to your requirements
  values = [ file("customizations/helm/prometheus/values.yaml") ]

}