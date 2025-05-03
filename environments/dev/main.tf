provider "libvirt" {
  uri = var.libvirt_uri
}

module "libvirt" {
  source = "../modules/libvirt"

  vm_count = var.vm_count
  vm_image = var.vm_image
  network_name = var.network_name
}

module "k0s" {
  source = "../modules/k0s"

  cluster_name = var.cluster_name
  node_count = var.node_count
  kubeconfig_path = module.libvirt.kubeconfig_path
}

module "argocd" {
  source = "../modules/argocd"

  kubeconfig = module.k0s.kubeconfig
  argocd_version = var.argocd_version
}

output "argocd_server_url" {
  value = module.argocd.argocd_server_url
}