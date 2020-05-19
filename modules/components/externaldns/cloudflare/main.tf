resource "null_resource" "dependency_getter" {
  count = var.externaldns_provider == "cloudflare" ? 1 : 0
  triggers = {
    instance = join(",", var.dependencies)
  }
}

resource "helm_release" "external-dns" {
  count = var.externaldns_provider == "cloudflare" ? 1 : 0
  depends_on = [null_resource.dependency_getter]
  name       = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  version    = var.externaldns_helm_chart_version
  namespace = "external-dns"
  create_namespace = true
  force_update = true
  
  values = []

  set {
    name  = "provider"
    value = var.externaldns_provider
  }

  set {
      name = "domainsFilter"
      value = var.dns_domains
  }

  set {
      name = "domainsFilter"
      value = var.dns_domains
  }

  set {
    name  = "cloudflare.apiKey"
    value = var.dns_api_key
  }

  set {
    name  = "cloudflare.email"
    value = var.dns_api_email
  }

  set {
      name = "cloudflare.proxied"
      value = false
  }

  set {
      name = "rbac.enabled"
      value = true
  }

  set {
      name = "rbac.serviceAccountName"
      value = "external-dns"
  }

  set {
      name = "rbac.apiVersion"
      value = "v1"
  }

  set {
      name = "replicas"
      value = "1"
  }

  set {
      name = "metrics.enabled"
      value = false
  }

}