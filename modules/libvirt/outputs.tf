# Outputs for the libvirt module

output "controller_ips" {
  description = "IP addresses of controller nodes"
  value = {
    for name, domain in libvirt_domain.this : 
      name => domain.network_interface[0].addresses[0] 
      if domain.description == "k0s-controller"
  }
}

output "worker_ips" {
  description = "IP addresses of worker nodes"
  value = {
    for name, domain in libvirt_domain.this : 
      name => domain.network_interface[0].addresses[0] 
      if domain.description == "k0s-worker"
  }
}
