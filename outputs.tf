output "k0s_controller_ips" {
  description = "IP addresses of the k0s controller nodes"
  value       = module.libvirt.controller_ips
}

output "k0s_worker_ips" {
  description = "IP addresses of the k0s worker nodes"
  value       = module.libvirt.worker_ips
}
