data "helm_repository" "certmanager" {
  count = var.certmanager_provider != "none" ? 1 : 0
  name = "jetstack"
  url  = "https://charts.jetstack.io"
}

resource "null_resource" "dependency_getter" {
  count = var.certmanager_provider == "cloudflare" ? 1 : 0
  triggers = {
    instance = join(",", var.dependencies)
  }
}

resource "local_file" "kube_config" {
  count = var.certmanager_provider == "cloudflare" ? 1 : 0
  content  = var.kube_config
  filename = "${path.root}/build/kube_config.yaml"
}

resource "null_resource" "apply_crds" {
  count = var.certmanager_provider == "cloudflare" ? 1 : 0
  provisioner "local-exec" {
    command = "kubectl apply --kubeconfig ${path.root}/build/kube_config.yaml --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v${var.certmanager_helm_chart_version}/cert-manager.crds.yaml"
  }
  depends_on = [null_resource.dependency_getter, local_file.kube_config]
}

resource "kubernetes_namespace" "certmanager" {
  count = var.certmanager_provider == "cloudflare" ? 1 : 0
  metadata {
    annotations = {
      name = "cert-manager"
    }
    name = "cert-manager"
  }
}

resource "helm_release" "cert_manager" {
  count = var.certmanager_provider == "cloudflare" ? 1 : 0
  depends_on = [null_resource.dependency_getter, kubernetes_namespace.certmanager, null_resource.apply_crds]
  name       = "cert-manager"
  repository = data.helm_repository.certmanager[0].metadata[0].name
  chart      = "cert-manager"
  version    = "v${var.certmanager_helm_chart_version}"
  namespace  = "cert-manager"

  values = []
}

resource "kubernetes_secret" "cloudflare-api-key-secret" {
  count = var.certmanager_provider == "cloudflare" ? 1 : 0
  metadata {
    name      = "cloudflare-api-key-secret"
    namespace = "cert-manager"
  }
  data = {
    api-key: var.dns_api_key
  }
}

resource "local_file" "issuer" {
  count = var.certmanager_provider == "cloudflare" ? 1 : 0
  content  = templatefile("${path.module}/issuer.yaml", {
      dns_api_key = var.dns_api_key,
      dns_api_email = var.dns_api_email,
      dns_domains = var.dns_domains
  })
  filename = "${path.root}/build/issuer.yaml"
}

resource "null_resource" "issuer_letsencrypt" { 
  count = var.certmanager_provider == "cloudflare" ? 1 : 0

  provisioner "local-exec" {
    command = "kubectl --kubeconfig ${path.root}/build/kube_config.yaml apply -f ${local_file.issuer[0].filename}"
  }

  depends_on = [
    null_resource.dependency_getter,
    helm_release.cert_manager,
    local_file.kube_config
  ]
}

resource "null_resource" "dependency_setter" {
  count = var.certmanager_provider == "cloudflare" ? 1 : 0
  depends_on = [
    helm_release.cert_manager
  ]
}