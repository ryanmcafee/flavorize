resource "null_resource" "dependency_getter" {
  count = var.prometheus_enabled == "true" ? 1 : 0
  triggers = {
    instance = join(",", var.dependencies)
  }
}

resource "helm_release" "prometheus" {
  count = var.prometheus_enabled == "true" ? 1 : 0
  name       = var.name
  chart      = "prometheus-operator"
  version    = var.prometheus_chart_version
  repository = var.repository
  depends_on = [null_resource.dependency_getter]
  # Todo: Support setting the namespace via terraform variable
  # Defaulting this to kube-system to support external oauth authentication for prometheus, alertmanager and grafana ingresses
  namespace = var.namespace
  create_namespace = var.create_namespace
  force_update = var.force_update

  # Fetch latest from https://github.com/helm/charts/blob/master/stable/prometheus/values.yaml and modify for your purposes.
  # File should be stored in customizations/prometheus-operator/values.yaml. This file is not tracked in git to allow more advanced customizations.
  # You can also override the prometheus-operator chart values location by setting the variable: prometheus_chart_custom_values to the path of your values.yaml file.
  # You will likely want to override the prometheus_chart_custom_values location when using workspace to store config file per workspace.
  # Apply helm prometheus configuration specific to your requirements
  values = fileexists(var.prometheus_chart_custom_values) ? [ file(var.prometheus_chart_custom_values) ] : []

}