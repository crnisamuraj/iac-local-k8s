terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.8.3"
    }
    k0s = {
      source = "alessiodionisi/k0s"
    }
  }
  required_version = ">= 1.4.0"
}
