# variable "kubeconfig_path" {
#   description = "Path to the kubeconfig file"
#   default     = ""
# }

# variable "kubeconfig" {
#   description = "Kubeconfig content"
#   default     = ""
# }

variable "namespace" {
  description = "Namespace for ArgoCD"
  default     = "argocd"
}

variable "create_namespace" {
  description = "Whether to create the namespace"
  default     = true
}

variable "argocd_version" {
  description = "Version of the ArgoCD Helm chart"
  default     = "5.33.1"  # Update to latest stable version
}

variable "values_path" {
  description = "Path to the values.yaml file for ArgoCD"
  default     = "values.yaml"
  
}
