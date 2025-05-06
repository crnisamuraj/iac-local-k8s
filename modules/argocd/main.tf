resource "kubernetes_namespace" "argocd" {
  count = var.create_namespace ? 1 : 0
  
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argocd_version
  namespace  = var.namespace
  
  values = [
    file("${var.values_path}")
  ]
  
  depends_on = [kubernetes_namespace.argocd]
}
