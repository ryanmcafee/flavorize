variable certmanager_provider {
    type = string
    default = "none"
}

variable certmanager_solver {
    type = string
    default = "HTTP01"
}

variable certmanager_email {
    type = string
    default = ""
}

variable ingress_class {
    type = string
    default = "nginx"
}

variable certmanager_helm_chart_version {
    type = string
    default = "0.15.0"
}

variable dns_api_key {
    type = string
    default = "none"
}

variable dns_api_email {
    type = string
    default = "none"
}

variable dns_domains {
    type = string
    default = "none"
}

variable dependencies {
  description = "Create a dependency between the resources in this module to the interpolated values in this list (and thus the source resources). In other words, the resources in this module will now depend on the resources backing the values in this list such that those resources need to be created before the resources in this module, and the resources in this module need to be destroyed before the resources in the list."
  type        = list(string)
  default     = []
}

variable kube_config {
    type = string
}