resource "null_resource" "dependency_getter" {
  count = var.prometheus_enabled == "true" ? 1 : 0
  triggers = {
    instance = join(",", var.dependencies)
  }
}

resource "helm_release" "prometheus" {
  count = var.prometheus_enabled == "true" ? 1 : 0
  # Todo: Support setting the helm release name via terraform variable
  name       = "ops"
  chart      = "prometheus-operator"
  version    = var.prometheus_chart_version
  repository = "https://kubernetes-charts.storage.googleapis.com"
  depends_on = [null_resource.dependency_getter]
  # Todo: Support setting the namespace via terraform variable
  # Defaulting this to kube-system to support external oauth authentication for prometheus, alertmanager and grafana ingresses
  namespace = "kube-system"
  create_namespace = true
  force_update = true

  # Fetch latest from https://github.com/helm/charts/blob/master/stable/prometheus/values.yaml and modify for your purposes.
  # File should be stored in customizations/helm/prometheus/values.yaml. This file is not tracked in git to allow more advanced customizations.
  # Apply helm prometheus configuration specific to your requirements
  # Todo: Default this to chart values from upstream via http, but support specifying file location via terraform variable.
  values = [ file("customizations/helm/prometheus/values.yaml") ]

}