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
  depends_on = [null_resource.dependency_getter]
}

resource "helm_release" "cert_manager" {
  count = var.certmanager_provider == "cloudflare" ? 1 : 0
  depends_on = [null_resource.dependency_getter]
  name       = "cert-manager"
  repository = "https://charts.jetstack.io/"
  chart      = "cert-manager"
  version    = "v${var.certmanager_helm_chart_version}"
  namespace  = "cert-manager"
  create_namespace = true
  force_update = true
  dependency_update = true
  skip_crds = false
  disable_crd_hooks = false

  values = []

  set {
    name = "installCRDS"
    value = "true"
  }
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
  depends_on = [null_resource.dependency_getter, local_file.kube_config, helm_release.cert_manager]
}

resource "local_file" "issuer_http_solver" {
  count = var.certmanager_provider == "cloudflare" && var.certmanager_solver == "HTTP01" ? 1 : 0
  content  = templatefile("${path.module}/issuer-http-solver.yaml", {
      certmanager_email = var.certmanager_email,
      certmanager_solver = var.certmanager_solver,
      ingress_class = var.ingress_class
  })
  filename = "${path.root}/build/issuer-http-solver.yaml"
  depends_on = [null_resource.dependency_getter, local_file.kube_config, helm_release.cert_manager]
}

resource "null_resource" "issuer_http_solver_apply" { 
  count = var.certmanager_provider == "cloudflare" && var.certmanager_solver == "HTTP01" ? 1 : 0

  provisioner "local-exec" {
    command = "kubectl --kubeconfig ${local_file.kube_config[0].filename} apply -f ${local_file.issuer_http_solver[0].filename}"
  }

  depends_on = [
    null_resource.dependency_getter,
    helm_release.cert_manager,
    local_file.kube_config,
    local_file.issuer_http_solver
  ]
}

resource "local_file" "issuer_dns_solver" {
  count = var.certmanager_provider == "cloudflare" && var.certmanager_solver == "DNS01" ? 1 : 0
  content  = templatefile("${path.module}/issuer-dns-solver.yaml", {
      dns_api_key = var.dns_api_key,
      certmanager_email = var.certmanager_email,
      dns_domains = var.dns_domains
  })
  filename = "${path.root}/build/issuer-dns-solver.yaml"
  depends_on = [null_resource.dependency_getter, local_file.kube_config, helm_release.cert_manager]
}

resource "null_resource" "issuer_dns_solver_apply" { 
  count = var.certmanager_provider == "cloudflare" && var.certmanager_solver == "DNS01" ? 1 : 0

  provisioner "local-exec" {
    command = "kubectl --kubeconfig ${local_file.kube_config[0].filename} apply -f ${local_file.issuer_dns_solver[0].filename}"
  }

  depends_on = [
    null_resource.dependency_getter,
    helm_release.cert_manager,
    local_file.kube_config,
    local_file.issuer_dns_solver
  ]
}
