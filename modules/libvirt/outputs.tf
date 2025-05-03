output "vm_ips" {
  value = libvirt_domain.this.*.network_interface[0].addresses
}

output "vm_names" {
  value = libvirt_domain.this.*.name
}

output "network_name" {
  value = libvirt_network.this.name
}

output "network_cidr" {
  value = libvirt_network.this.addresses
}

output "control_node_ips" {
  value = [for name in slice(keys(libvirt_domain.vms), 0, var.vm_count_control) : libvirt_domain.vms[name].network_interface.0.addresses[0]]
}

output "worker_node_ips" {
  value = [for name in slice(keys(libvirt_domain.vms), var.vm_count_control, var.vm_count_control + var.vm_count_workers) : libvirt_domain.vms[name].network_interface.0.addresses[0]]
}
