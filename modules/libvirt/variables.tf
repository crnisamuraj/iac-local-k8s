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
    root_volume_size = number
    nodes = map(object({
      role = string
      memory = number
      vcpu = number
      data_volume_size = number
      addresses = list(string)
    }))
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
      path = "/var/libvirt"
    }
    base_volume = {
      source = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"
    }
    root_volume_size = 30000000000
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
    username = "debian"
    ssh_private_key_path = "~/.ssh/id_rsa"
    ssh_public_key_path = "~/.ssh/id_rsa.pub"
  }
}
