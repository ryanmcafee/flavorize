data "helm_repository" "externaldns" {
  count = var.externaldns_provider == "cloudflare" ? 1 : 0
  name = "stable"
  url  = "https://charts.bitnami.com/bitnami"
}

resource "null_resource" "dependency_getter" {
  count = var.externaldns_provider == "cloudflare" ? 1 : 0
  triggers = {
    instance = join(",", var.dependencies)
  }
}

resource "kubernetes_namespace" "external-dns" {
  count = var.externaldns_provider == "cloudflare" ? 1 : 0
  depends_on = [null_resource.dependency_getter]
  metadata {
    annotations = {
      name = "external-dns"
    }
    name = "external-dns"
  }
}

resource "helm_release" "external-dns" {
  count = var.externaldns_provider == "cloudflare" ? 1 : 0
  depends_on = [kubernetes_namespace.external-dns]
  name       = "external-dns"
  repository = data.helm_repository.externaldns[0].metadata[0].name
  chart      = "external-dns"
  version    = var.externaldns_helm_chart_version
  namespace = "external-dns"

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