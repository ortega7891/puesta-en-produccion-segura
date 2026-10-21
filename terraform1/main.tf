terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.112"
    }
  }
}

provider "proxmox" {
  endpoint  = "https://172.16.90.200:8006/"
  api_token = var.proxmox_api_token
  insecure  = true
}

variable "proxmox_api_token" {
  type      = string
  sensitive = true
}

locals {
  vms = {
    BBDDSergioOrtega = {
      vm_id    = 101
      ip       = "172.16.90.151/24"
      hostname = "servidorBBDDSergioOrtega"
      package  = "python3-pip"
      service  = null
      upgrade  = false
    }

    WEB2SergioOrtega = {
      vm_id    = 102
      ip       = "172.16.90.152/24"
      hostname = "servidorWebSergioOrtega"
      package  = "nginx"
      service  = "nginx"
      upgrade  = false
    }

    WEB3SergioOrtega = {
      vm_id    = 103
      ip       = "172.16.90.153/24"
      hostname = "servidorWeb2SergioOrtega"
      package  = "apache2"
      service  = "apache2"
      upgrade  = true
    }
  }
}

resource "proxmox_virtual_environment_vm" "ubuntu" {
  for_each = local.vms

  name      = each.key
  vm_id     = each.value.vm_id
  node_name = "pve"

  clone {
    vm_id = 500
  }

  cpu {
    cores = 2
    type  = "host"
  }

  memory {
    dedicated = 1024
  }

  network_device {
    bridge = "vmbr0"
  }

  initialization {
    ip_config {
      ipv4 {
        address = each.value.ip
        gateway = "172.16.90.2"
      }
    }

    user_account {
      username = "ubuntu"

      keys = [
        trimspace(file(pathexpand("~/.ssh/id_rsa.pub")))
      ]
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname ${each.value.hostname}",
      "sudo apt-get update",
      each.value.upgrade ? "sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y" : "true",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get install -y ${each.value.package}",
      each.value.service != null ? "sudo systemctl enable --now ${each.value.service}" : "true"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = split("/", each.value.ip)[0]
      private_key = file(pathexpand("~/.ssh/id_rsa"))
      timeout     = "10m"
    }
  }

  started = true
}
