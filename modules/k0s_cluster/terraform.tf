terraform {
  required_providers {
    k0s = {
      source  = "alessiodionisi/k0s"
      version = "0.2.2"
    }
    # helm = {
    #   source = "hashicorp/helm"
    #   version = "2.13.2"
    # }
  }
}

# provider "helm" {
#   kubernetes {
#     config_path = "${k0s_cluster.this.name}-kube.config"
#   }
# }
