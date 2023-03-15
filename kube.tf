
variable "hcloud_token" {
  type      = string
  sensitive = true
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

module "kube-hetzner" {
  providers = {
    hcloud = hcloud
  }
  hcloud_token = var.hcloud_token
  source  = "kube-hetzner/kube-hetzner/hcloud"
  version = "1.10.3"
  ssh_public_key = tls_private_key.example.public_key_openssh
  ssh_private_key = tls_private_key.example.private_key_pem
  network_region = "eu-central"
  control_plane_nodepools = [
    {
      name        = "control-plane-fsn1",
      server_type = "cx21",
      location    = "fsn1",
      labels      = [],
      taints      = [],
      count       = 1
    },
  ]
  agent_nodepools = [
    {
      name        = "agent-fsn1",
      server_type = "cx31",
      location    = "fsn1",
      labels      = [],
      taints      = [],
      count       = 2
    },
  ]
  load_balancer_type     = "lb11"
  load_balancer_location = "fsn1"
}

provider "hcloud" {
  token = local.hcloud_token
}

terraform {
  required_version = ">= 1.3.3"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.35.2"
    }
  }
}

# terraform output --raw kubeconfig > ~/.kube/config
output "kubeconfig" {
  value     = module.kube-hetzner.kubeconfig
  sensitive = true
}

output "ssh_private_key" {
  value = tls_private_key.example.private_key_pem
  sensitive = true
}
