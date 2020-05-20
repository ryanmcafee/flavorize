provider "azurerm" {
    version = "~>2.10.0"
    subscription_id = var.arm_subscription_id
    client_id       = var.arm_client_id
    client_secret   = var.arm_client_secret
    tenant_id       = var.arm_tenant_id
    features {}
}

variable "do_token" {
  default = ""
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  version = "~> 1.18"
  token = var.do_token
}

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
    token                  = module.k8s.token
    host                   = module.k8s.host
    client_certificate     = base64decode(module.k8s.client_certificate)
    client_key             = base64decode(module.k8s.client_key)
    cluster_ca_certificate = base64decode(module.k8s.cluster_ca_certificate)
  }
}

provider "kubernetes" {
  version = "~> 1.11"
  load_config_file       = false
  token                  = module.k8s.token
  host                   = module.k8s.host
  client_certificate     = base64decode(module.k8s.client_certificate)
  client_key             = base64decode(module.k8s.client_key)
  cluster_ca_certificate = base64decode(module.k8s.cluster_ca_certificate)
}