resource "libvirt_network" "this" {
  name = "${var.libvirtcluster.name}-${var.libvirtcluster.network.mode}"
  mode = var.libvirtcluster.network.mode
  domain = "${var.libvirtcluster.name}.local"
  addresses = var.libvirtcluster.network.addresses
  autostart = true

  dns {
    enabled = var.libvirtcluster.network.dns.enabled
    local_only = var.libvirtcluster.network.dns.local_only
  }
}

resource "libvirt_pool" "this" {
  name = var.libvirtcluster.name
  type = "dir"
  target {
    path = var.libvirtcluster.volume_pool.path
  }
}

data "template_file" "user_data" {
  template = file("${path.root}/cloud-init/cloud_init.cfg")
}

data "template_file" "network_config" {
  template = file("${path.root}/cloud-init/network_config.cfg")
}

resource "libvirt_cloudinit_disk" "this" {
  name      = "${var.libvirtcluster.name}-commoninit"
  pool      = libvirt_pool.this.name
  user_data = data.template_file.user_data.rendered
  network_config = data.template_file.network_config.rendered
}

resource "libvirt_volume" "base" {
  name      = "${var.libvirtcluster.name}-debian-base.qcow2"
  pool      = libvirt_pool.this.name
  source    = var.libvirtcluster.base_volume.source
}

resource "null_resource" "resize_base_image" {
  provisioner "local-exec" {
    command = "sudo ${abspath(path.root)}/scripts/resize-disk.sh ${var.libvirtcluster.volume_pool.path}/${var.libvirtcluster.name}-debian-base.qcow2 ${var.libvirtcluster.volume_pool.path}/${var.libvirtcluster.name}-debian-base-resized.qcow2 40G"
  }
  depends_on = [ libvirt_volume.base ]
}

resource "libvirt_volume" "resized_base" {
  depends_on = [null_resource.resize_base_image]
  name       = "${var.libvirtcluster.name}-debian-base-resized.qcow2"
  pool       = libvirt_pool.this.name
  source     = "${var.libvirtcluster.volume_pool.path}/${var.libvirtcluster.name}-debian-base-resized.qcow2"
}

resource "libvirt_volume" "root" {
  for_each  = var.libvirtcluster.nodes
  name      = "${var.libvirtcluster.name}-${each.key}-root.qcow2"
  pool      = libvirt_pool.this.name
  base_volume_id = libvirt_volume.resized_base.id
}

resource "libvirt_volume" "data" {
  for_each  = var.libvirtcluster.nodes
  name      = "${var.libvirtcluster.name}-${each.key}-data.qcow2"
  pool      = libvirt_pool.this.name
  size      = each.value.data_volume_size
}

resource "libvirt_domain" "this" {
  for_each = var.libvirtcluster.nodes
  name     = each.key
  description = "k0s-${each.value.role}"
  memory   = each.value.memory
  vcpu     = each.value.vcpu
  qemu_agent = true
  type     = "kvm"

  disk {
    volume_id = libvirt_volume.root[each.key].id
  }

  disk {
    volume_id = libvirt_volume.data[each.key].id
  }

  network_interface {
    network_id = libvirt_network.this.id
    hostname  = each.key
    addresses = each.value.addresses
    wait_for_lease = true
  }

  cloudinit = libvirt_cloudinit_disk.this.id

  lifecycle {
    ignore_changes = [cmdline, cpu]
  }
}
