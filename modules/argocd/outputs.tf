output "argocd_namespace" {
  value = var.namespace
}

output "argocd_local_url" {
  value = "argocd-server.${var.namespace}.svc.cluster.local"
}

# output "argocd_url" {
#   value = "https://${kubernetes_service.argocd_server[0].status[0].load_balancer[0].ingress[0].hostname}"
#   description = "URL to access ArgoCD UI"
# }