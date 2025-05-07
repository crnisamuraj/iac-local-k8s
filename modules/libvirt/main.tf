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

locals {
  user_data = templatefile("${path.root}/cloud-init/cloud_init.cfg", {
    username = var.libvirtcluster.username
    ssh_public_key = file(pathexpand(var.libvirtcluster.ssh_public_key_path))
  })
  network_config = templatefile("${path.root}/cloud-init/network_config.cfg", {})
}

resource "libvirt_cloudinit_disk" "this" {
  name      = "${var.libvirtcluster.name}-commoninit"
  pool      = libvirt_pool.this.name
  user_data = local.user_data
  network_config = local.network_config
}

resource "libvirt_volume" "base" {
  name      = "${var.libvirtcluster.name}-debian-base.qcow2"
  pool      = libvirt_pool.this.name
  source    = var.libvirtcluster.base_volume.source
}

locals {
  # Add 4GB (4,294,967,296 bytes) to the root volume size
  root_increased_size = var.libvirtcluster.root_volume_size + 5694967296
  # Convert the size to GB
  root_size_gb = "${floor(var.libvirtcluster.root_volume_size / 1000000000)}G"
  root_increased_size_gb = "${floor(local.root_increased_size / 1000000000)}G"
}

resource "libvirt_volume" "resized_base" {
  name       = "${var.libvirtcluster.name}-debian-base-resized.qcow2"
  pool       = libvirt_pool.this.name
  size = local.root_increased_size
}

# todo: refactor the command so that availavle elevation methods are used via script not inline and expand to macos
# The script `resize-disk.sh` is a custom script that resizes the disk image.
resource "null_resource" "resize_base_image" {
  provisioner "local-exec" {
    command = <<-EOT
      ${abspath(path.root)}/scripts/resize-disk.sh \
        ${var.libvirtcluster.volume_pool.path}/${var.libvirtcluster.name}-debian-base.qcow2 \
        ${var.libvirtcluster.volume_pool.path}/${var.libvirtcluster.name}-debian-base-resized.qcow2 \
        ${local.root_increased_size_gb} \
        ${local.root_size_gb} || \
      echo "----------------------------------------------------------" && \
      echo "---------- Resize disk failed, trying with sudo ----------" && \
      echo "----------------------------------------------------------" && \
      pkexec ${abspath(path.root)}/scripts/resize-disk.sh \
        ${var.libvirtcluster.volume_pool.path}/${var.libvirtcluster.name}-debian-base.qcow2 \
        ${var.libvirtcluster.volume_pool.path}/${var.libvirtcluster.name}-debian-base-resized.qcow2 \
        ${local.root_increased_size_gb} \
        ${local.root_size_gb} || \
      sudo ${abspath(path.root)}/scripts/resize-disk.sh \
        ${var.libvirtcluster.volume_pool.path}/${var.libvirtcluster.name}-debian-base.qcow2 \
        ${var.libvirtcluster.volume_pool.path}/${var.libvirtcluster.name}-debian-base-resized.qcow2 \
        ${local.root_increased_size_gb} \
        ${local.root_size_gb}
    EOT
  }
  depends_on = [ libvirt_volume.base, libvirt_volume.resized_base ]
}

resource "libvirt_volume" "root" {
  for_each  = var.libvirtcluster.nodes
  name      = "${var.libvirtcluster.name}-${each.key}-root.qcow2"
  pool      = libvirt_pool.this.name
  base_volume_id = libvirt_volume.resized_base.id
  depends_on = [ null_resource.resize_base_image ]
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
    ignore_changes = [cmdline, cpu, network_interface]
  }
}
