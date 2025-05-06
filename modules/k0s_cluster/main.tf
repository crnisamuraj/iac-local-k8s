resource "k0s_cluster" "this" {
  name    = var.cluster_name
  version = var.cluster_version

  hosts = var.cluster_nodes
}

resource "local_file" "kubeconfig" {
  content  = k0s_cluster.this.kubeconfig
  filename = "${k0s_cluster.this.name}-kube.config"
}