variable "name" { description = "Helm release name" type = string default = "argocd" }
variable "chart_repository" { description = "Helm chart repo" type = string default = "https://argoproj.github.io/argo-helm" }
variable "chart_name" { description = "Chart name" type = string default = "argo-cd" }
variable "chart_version" { description = "Chart version" type = string default = "4.13.8" }
variable "namespace" { description = "Namespace for ArgoCD" type = string default = "argocd" }
variable "values" { description = "Helm values overrides" type = list(any) default = [] }
