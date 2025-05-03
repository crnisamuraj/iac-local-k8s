resource "helm_release" "argocd" {
  name             = var.name
  repository       = var.chart_repository
  chart            = var.chart_name
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = true
  values           = var.values
}
