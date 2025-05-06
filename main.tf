module "libvirt" {
  source = "./modules/libvirt"
  libvirtcluster  = var.libvirtcluster
}

module "k0s_cluster" {
  source          = "./modules/k0s_cluster"
  cluster_name    = var.libvirtcluster.name
  cluster_version = var.libvirtcluster.k0s_cluster.version
  cluster_nodes = [
    for name, value in var.libvirtcluster.nodes : {
      role = value.role
      ssh = {
        address  = value.addresses[0]
        port = 22
        user     = var.libvirtcluster.username
        key_path = var.libvirtcluster.ssh_private_key_path
      }
      install_flags = (value.role == "controller" ? 
                      var.libvirtcluster.k0s_cluster.install_flags.controller : 
                      var.libvirtcluster.k0s_cluster.install_flags.worker)
    }
  ]

  depends_on = [ module.libvirt ]
}

module "argocd" {
  source = "./modules/argocd"
  namespace = var.argocd.namespace
  create_namespace = var.argocd.create_namespace
  values_path = var.argocd.values_path
  argocd_version = var.argocd.version
  
  depends_on = [module.k0s_cluster]
}
