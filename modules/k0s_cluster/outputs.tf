output "kubeconfig" {
  description = "kubeconfig"
  value       = k0s_cluster.this.kubeconfig
}

output "kubeconfig_path" {
  value = local_file.kubeconfig.filename
}