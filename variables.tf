variable "libvirtcluster" {
  description = "Libvirt cluster name"
  type        = object({
    name = string
    network = object({
      mode = string
      addresses = list(string)
      dns = object({
        enabled = bool
        local_only = bool
      })
    })
    volume_pool = object({
      path = string
    })
    base_volume = object({
      source = string
    })
    nodes = map(object({
      role = string
      memory = number
      vcpu = number
      data_volume_size = number
      addresses = list(string)
    }))
    k0s_cluster = object({
      version = string
      install_flags = object({
        controller = list(string)
        worker = list(string)
      })
    })
    username = string
    ssh_private_key_path = string
    ssh_public_key_path = string
  })
  
  default = {
    name = "k0s"
    network = {
      mode = "nat"
      addresses = ["192.168.99.0/24"]
      dns = {
        enabled = true
        local_only = false
      }
    }
    volume_pool = {
      path = "/var/libvirt-k0s"
    }
    base_volume = {
      source = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2" #"/home/vudu/Downloads/debian-12-generic-amd64-resized+15.qcow2"
    }
    nodes = {
      ctl1 = {
        role = "controller"
        memory = 2048
        vcpu = 2
        data_volume_size = 30000000000
        addresses = ["192.168.99.11"]
      }
      wrk1 = {
        role = "worker"
        memory = 2048
        vcpu = 2
        data_volume_size = 30000000000
        addresses = ["192.168.99.12"]
      }
    }
    k0s_cluster = {
      version = "1.30.1+k0s.0"
      install_flags = {
        controller = [
          "--data-dir=/data/k0s"
        ]
        worker = [
          "--data-dir=/data/k0s"
        ]
      }
    }
    username = "debian"
    ssh_private_key_path = "~/.ssh/id_rsa"
    ssh_public_key_path = "~/.ssh/id_rsa.pub"
  }
}

variable "argocd" {
  description = "ArgoCD configuration"
  type = object({
    namespace = string
    create_namespace = bool
    version = string
    values_path = string
  })
  
  default = {
    namespace = "argocd"
    create_namespace = true
    version = "7.9.0"
    values_path = "environments/dev/values/argocd.yaml"
  }
  
}

