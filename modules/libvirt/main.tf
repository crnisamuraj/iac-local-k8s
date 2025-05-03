locals {
  total_count = var.libvirtcluster.node_count_ctl + var.libvirtcluster.node_count_wrk
  names       = concat(
    [for i in range(var.libvirtcluster.node_count_ctl) : "${var.libvirtcluster.name}-ctl-${i+1}"],
    [for j in range(var.libvirtcluster.node_count_wrk) : "${var.libvirtcluster.name}-wrk-${j+1}"]
  )
}

resource "libvirt_network" "this" {
  name = "${var.libvirtcluster.name}-${var.libvirtcluster.network.mode}"
  mode = var.libvirtcluster.network.mode

  addresses = var.libvirtcluster.network.addresses
  dns = var.libvirtcluster.network.dns

  # dns {
  #   address = var.libvirtcluster.network.dns-string
  # }
}

resource "libvirt_volume" "this" {
  for_each  = toset(local.names)
  name      = "${each.key}.qcow2"
  pool      = var.volume_pool
  format    = "qcow2"
  size      = var.vm_disk_size
  source    = var.base_image_path
}

resource "libvirt_domain" "this" {
  for_each = toset(local.names)
  name     = each.key
  memory   = var.vm_memory
  vcpu     = var.vm_vcpu

  disk {
    volume_id = libvirt_volume.this[each.key].id
  }

  network_interface {
    network_id = libvirt_network.this.name
    hostname  = each.key
    wait_for_lease = true
  }

  cloudinit = libvirt_cloudinit_disk.common[each.key].id

  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "apt-get install -y docker.io",
      "sudo sysctl -w net.ipv4.ip_forward=1"
    ]
    connection {
      type        = "ssh"
      host        = self.network_interface.0.addresses[0]
      user        = var.vm_user
      private_key = file(var.ssh_private_key)
    }
  }

  lifecycle {
    ignore_changes = [network_interface]
  }
}

output "vm_ips" {
  value = [for d in libvirt_domain.this : d.network_interface[0].addresses[0]]
}