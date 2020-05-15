variable ingress_provider {
    type = string
    default = "none"
}

variable ingress_name {
    type = string
    default = "ingress-nginx"
}

variable ingress_helm_chart_version {
    type = string
    default = "2.1.0"
}

variable dependencies {
  description = "Create a dependency between the resources in this module to the interpolated values in this list (and thus the source resources). In other words, the resources in this module will now depend on the resources backing the values in this list such that those resources need to be created before the resources in this module, and the resources in this module need to be destroyed before the resources in the list."
  type        = list(string)
  default     = []
}