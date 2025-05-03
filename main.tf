module "libvirt" {
  source = "./modules/libvirt"
  libvirt_uri = var.libvirt_uri
  ssh_user     = var.ssh_user
  ssh_private_key_path = var.ssh_private_key_path
  ssh_public_key = var.ssh_public_key
  base_image    = var.base_image
  base_image_path = var.base_image_path
  volume_pool     = var.volume_pool
  vm_count_control = var.vm_count_control
  vm_count_workers = var.vm_count_workers
  vm_count        = var.vm_count
  vm_disk_size    = var.vm_disk_size
  vm_count       = var.vm_count
  vm_image       = var.base_image
  network_name   = var.network_name
  network_cidr   = var.network_cidr
  vm_memory      = var.vm_memory
  vm_vcpu        = var.vm_vcpu
}

module "k0s_cluster" {
  source          = "./modules/k0s_cluster"
  cluster_name    = var.k0s_clusters.cluster_name
  cluster_version = var.k0s_clusters.cluster_version
  cluster_nodes   = var.k0s_clusters.cluster_nodes
  # argo_git_url      = var.k0s_clusters.argo_config.git_url
  # argo_git_username = var.k0s_clusters.argo_config.username
  # argo_git_password = var.argo_git_password
  depends_on = [ module.libvirt ]
}

# module "argocd" {
#   source = "./modules/argocd"
#   depends_on = [ module.k0s_cluster ]
# }
