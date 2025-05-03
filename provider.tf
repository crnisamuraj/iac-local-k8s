terraform {
  required_providers {
    libvirt    = { source = "dmacvicar/libvirt"     version = "~> 0.7" }
    k0s        = { source = "imjos/k0s"             version = "~> 0.1" }
    kubernetes = { source = "hashicorp/kubernetes"   version = "~> 2.20" }
    helm       = { source = "hashicorp/helm"         version = "~> 2.7" }
  }
  required_version = ">= 1.4.0"
}

provider "libvirt" {
  uri = var.libvirt_uri
}

provider "k0s" {
  version = var.k0s_version
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }
}
