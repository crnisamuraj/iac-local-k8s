variable "libvirt_uri" {
  description = "Libvirt URI to connect to the hypervisor"
  type        = string
  default     = "qemu:///system"
}
variable "vm_count_control" { type = number }
variable "vm_count_workers" { type = number }

variable "network_name" {
  description = "Name of the network to attach the VMs"
  type        = string
  default     = "default"
}

variable "network_dns" {
  description = "Network CIDR for the VMs"
  type        = string
  default     = "1.1.1.1"
}

variable "volume_pool" {
  description = "Libvirt volume pool to use for VM disks"
  type        = string
  default     = "default"
}

variable "vm_disk_size" {
  description = "Disk size for each VM in GB"
  type        = number
  default     = 20
}

variable "base_image" {
  description = "Base image for the VMs (Debian or Fedora)"
  type        = string
  default     = "debian"
}
variable "base_image_path" { type = string }

variable "vm_memory" {
  description = "Memory allocated for each VM in MB"
  type        = number
  default     = 2048
}

variable "vm_vcpu" {
  description = "Number of CPUs allocated for each VM"
  type        = number
  default     = 2
}

variable "vm_user" {
  description = "Username for the VMs"
  type        = string
  default     = "ubuntu"
}

variable "ssh_private_key" { 
  description = "ssh private key the VMs"
  type = string 
}

variable "ssh_public_key" {
  description = "ssh public key the VMs"
  type        = string
}

variable "libvirtcluster" {
  description = "Libvirt cluster name"
  type        = object({
    name = string
    network = object({
      mode = string
      addresses = list(string)
      dns-string = string
      dns = object({
        address = string
      })
    })
    volume = object({
      pool = string
      format = string
      size = number
      source = string
    })
    nodes = list(object({
      role = string
      memory = number
      vcpu = number
      volume = object({
        format = string
        size = number
        source = string
      })
      provisioner = object({
        inline = list(string)
        ssh = object({
          user = string
          private_key_path = string
        })
      })
    }))
  })
  
  default = {
    name = "k0s"
    network = {
      mode = "nat"
      addresses = ["192.169.99.0/24"]
      dns-string = "1.1.1.1"
      dns = {
        address = "1.1.1.1"
      }
    }
    volume = {
      pool = "default"
      format = "qcow2"
      size = 20
      source = "/path/to/base/image.qcow2"
    }
    domain = {
      node_count_ctl = 1
      node_count_wrk = 2
      memory = 2048
      vcpu = 2
      # cloudinit = {
      #   user_data = <<EOF
      #     #cloud-config
      #     package_update: true
      #     package_upgrade: true
      #     packages:
      #       - docker.io
      #       - sysctl
      #     runcmd:
      #       - sysctl -w net.ipv4.ip_forward=1
      #   EOF
      # }
      provisioner = {
        inline = [
          "apt-get update",
          "apt-get install -y docker.io",
          "sudo sysctl -w net.ipv4.ip_forward=1"
        ]
        ssh-connection = {
          user        = "root"
          ssh_private_key_path = file(var.ssh_private_key)
        }
      }
    }
  }
  
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
