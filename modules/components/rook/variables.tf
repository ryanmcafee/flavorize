variable rook_enabled {
    type = string
    default = "false"
}

variable rook_helm_chart_version {
    type = string
    default = "v1.3.3"
}

variable rbac_enabled {
    type = string
    default = "true"
}

variable dependencies {
  description = "Create a dependency between the resources in this module to the interpolated values in this list (and thus the source resources). In other words, the resources in this module will now depend on the resources backing the values in this list such that those resources need to be created before the resources in this module, and the resources in this module need to be destroyed before the resources in the list."
  type        = list(string)
  default     = []
}