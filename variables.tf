variable "libvirt_uri" {
  description = "Libvirt connection URI"
  type        = string
  default     = "qemu:///system"
}

variable "k0s_version" {
  description = "Version of k0s distribution to install"
  type        = string
  default     = "v1.28.0+k0s.0"
}

variable "kubeconfig_path" {
  description = "Path to kubeconfig file for Kubernetes and Helm providers"
  type        = string
  default     = "~/.kube/config"
}
variable "network_cidr" { description = "CIDR for the libvirt network" type = string }
variable "base_image_path" { description = "Path to base image qcow2" type = string }
variable "vm_count_control" { description = "Number of control plane VMs" type = number }
variable "vm_count_workers" { description = "Number of worker VMs" type = number }
variable "vm_vcpu" { description = "vCPUs per VM" type = number }
variable "ssh_user" { description = "SSH user for provisioning" type = string }
variable "ssh_private_key_path" { description = "SSH private key path" type = string }
variable "k0s_install_method" { description = "Method to install k0s (binary/package)" type = string }
variable "k0s_args" { description = "Extra args for k0s config" type = list(string) }

### libvirt
variable "libvirt_uri" {
  description = "The URI for the libvirt provider."
  type        = string
}

variable "vm_count" {
  description = "Number of virtual machines to create."
  type        = number
  default     = 3
}

variable "vm_memory" {
  description = "Memory allocated for each VM in MB."
  type        = number
  default     = 2048
}

variable "vm_cpus" {
  description = "Number of CPUs allocated for each VM."
  type        = number
  default     = 2
}

variable "vm_disk_size" {
  description = "Disk size for each VM in GB."
  type        = number
  default     = 20
}

variable "network_name" {
  description = "The name of the network to be used for the VMs."
  type        = string
}

variable "k0s_cluster_name" {
  description = "The name of the k0s Kubernetes cluster."
  type        = string
  default     = "k0s-cluster"
}

variable "k0s_version" {
  description = "The version of k0s to install."
  type        = string
  default     = "v0.14.0"
}

variable "argocd_version" {
  description = "The version of ArgoCD to install."
  type        = string
  default     = "v2.4.0"
}

variable "argocd_admin_password" {
  description = "The admin password for ArgoCD."
  type        = string
  sensitive   = true
}

variable "base_image" {
  description = "Base image for the VMs (debian or fedora)."
  type        = string
  default     = "debian"
}


### k0s-cluster
variable "k0s_clusters" {
  description = "K0s clusters map"
  type = object({
    cluster_name = string
    cluster_nodes = set(object({
      role = string
      ssh = object({
        address  = string
        user     = string
        port     = number
        key_path = string
      })
      install_flags = list(string)
    }))
    cluster_version = string
    # argo_config = object({
    #   git_url  = string
    #   username = string
    # })
  })


  default = {
    cluster_name    = "default"
    cluster_version = "1.30.0+k0s.0"

    cluster_nodes = [

      {
        role = "controller"
        ssh = {
          address  = "ip.or.domain.name"
          port     = 22
          user     = "root"
          key_path = "~/.ssh/id_rsa"
        }
        install_flags = ["--force"]
      },
      {
        role = "worker"
        ssh = {
          address  = "ip.or.domain.name"
          port     = 22
          user     = "root"
          key_path = "~/.ssh/id_rsa"
        }
        install_flags = ["--force"]
      },
      {
        role = "worker"
        ssh = {
          address  = "ip.or.domain.name"
          port     = 22
          user     = "root"
          key_path = "~/.ssh/id_rsa"
        }
        install_flags = ["--force"]
      }


    ]

    # argo_config = {
    #   git_url  = ""
    #   username = ""
    # }

  }

}

# variable "argo_git_password" {
#   type = string
# }