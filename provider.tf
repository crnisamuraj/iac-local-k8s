provider "libvirt" {
  uri = "qemu:///system"
}


provider "kubernetes" {
  config_path = module.k0s_cluster.kubeconfig_path
}

provider "helm" {
  kubernetes {
    config_path = module.k0s_cluster.kubeconfig_path
  }
}