variable "cluster_name" {
  description = "K0s cluster name"
  type        = string
}

variable "cluster_version" {
  description = "K0s cluster version"
  type        = string
}

variable "cluster_nodes" {
  description = "Map of nodes"
  type = set(object({
    role = string
    ssh = object({
      address  = string
      user     = string
      port     = number
      key_path = string
    })
    install_flags = list(string)
  }))
}

# variable "argo_git_url" {
#   description = "ArgoCD gitops url"
#   type = string
# }

# variable "argo_git_username" {
#   description = "ArgoCD gitops username"
#   type = string
# }

# variable "argo_git_password" {
#   description = "ArgoCD gitops password"
#   type = string
# }
