provider "local" {
  version = "~> 1.4"
}

provider "null" {
  version = "~> 2.1"
}

provider "helm" {
  version = "~> 1.2.1"
  kubernetes {
    load_config_file       = false
    token                  = var.k8s.token
    host                   = var.k8s.host
    client_certificate     = base64decode(var.k8s.client_certificate)
    client_key             = base64decode(var.k8s.client_key)
    cluster_ca_certificate = base64decode(var.k8s.cluster_ca_certificate)
  }
}

provider "kubernetes" {
  version = "~> 1.11"
  load_config_file       = false
  token                  = var.k8s.token
  host                   = var.k8s.host
  client_certificate     = base64decode(var.k8s.client_certificate)
  client_key             = base64decode(var.k8s.client_key)
  cluster_ca_certificate = base64decode(var.k8s.cluster_ca_certificate)
}