provider "azurerm" {
    version = "~>2.7.0"
    features {}
}

provider "local" {
  version = "~> 1.4"
}

provider "null" {
  version = "~> 2.1"
}

provider "helm" {
  version = "~> 1.1.1"
  kubernetes {
    load_config_file       = false
    host                   = module.k8s.host
    username               = module.k8s.cluster_username
    password               = module.k8s.cluster_password
    client_certificate     = base64decode(module.k8s.client_certificate)
    client_key             = base64decode(module.k8s.client_key)
    cluster_ca_certificate = base64decode(module.k8s.cluster_ca_certificate)
  }
}

provider "kubernetes" {
  version = "~> 1.11"
  load_config_file       = false
  host                   = module.k8s.host
  username               = module.k8s.cluster_username
  password               = module.k8s.cluster_password
  client_certificate     = base64decode(module.k8s.client_certificate)
  client_key             = base64decode(module.k8s.client_key)
  cluster_ca_certificate = base64decode(module.k8s.cluster_ca_certificate)
}