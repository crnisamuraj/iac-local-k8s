output "argocd_namespace" {
  value = var.namespace
}

output "argocd_server_url" {
  value = "argocd-server.${var.namespace}.svc.cluster.local"
}
