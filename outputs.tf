output "network_name" {
  value = module.network.network_name
}

output "control_ips" {
  value = module.compute.control_node_ips
}

output "worker_ips" {
  value = module.compute.worker_node_ips
}

output "argocd_server_url" {
  value = module.argocd.argocd_server_url
}
