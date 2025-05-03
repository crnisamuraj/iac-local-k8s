# Terraform k0s GitOps

This project provisions:
- A Libvirt network
- Debian/Fedora VMs (control + workers)
- A k0s Kubernetes cluster
- Argo CD via Helm

## Usage

```bash
terraform init -var-file=environments/dev.tfvars
terraform apply -var-file=environments/dev.tfvars
```

Ensure you have:
- Terraform >= 1.4.0
- Libvirt provider
- A base image QCOW2 downloaded locally
- SSH access configured (key & user)
