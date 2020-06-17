variable externaldns_enabled {
    type = string
    default = "false"
}

variable externaldns_helm_chart_version {
    type = string
    default = "2.22.1"
}

variable externaldns_chart_custom_values {
  type = string
  default = "customizations/externaldns/values.yaml"
}

variable namespace {
    type = string
    default = "kube-system"
}

variable name {
    type = string
    default = "external-dns"
}

variable repository {
    type = string
    default = "https://charts.bitnami.com/bitnami"
}

variable create_namespace {
    type = string
    default = "true"
}

variable force_update {
    type = string
    default = "true"
}

variable dependencies {
  description = "Create a dependency between the resources in this module to the interpolated values in this list (and thus the source resources). In other words, the resources in this module will now depend on the resources backing the values in this list such that those resources need to be created before the resources in this module, and the resources in this module need to be destroyed before the resources in the list."
  type        = list(string)
  default     = []
}