variable "vms" {
  type = list(object({
    name     = string
    vm_id    = string
    address  = string
    username = string
  }))
  description = "Список виртуальных машин"
  default = [
    {
      name     = "mobilepark1"
      vm_id    = "7241"
      address  = "192.168.7.241/24"
      username = "ansible"
    },
    {
      name     = "mobilepark2"
      vm_id    = "7242"
      address  = "192.168.7.242/24"
      username = "ansible"
    },
    {
      name     = "mobilepark3"
      vm_id    = "7243"
      address  = "192.168.7.243/24"
      username = "ansible"
    }
  ]
}

# Создание виртуальных машин
resource "proxmox_virtual_environment_vm" "vm" {
  for_each = { for vm in var.vms : vm.name => vm }

  vm_id       = each.value.vm_id
  name        = each.value.name
  node_name   = "pve"
  migrate     = true
  description = "OpenTofu Managed"
  on_boot     = true

  clone {
    vm_id     = "9001"
    node_name = "pve"
    retries   = 3
  }

  agent {
    enabled = true
  }

  operating_system {
    type = "l26"
  }

  cpu {
    sockets = 2
    cores   = 2
    type    = "host"
    numa    = true
  }

  memory {
    dedicated = 4096
  }

  disk {
    size         = "20"
    interface    = "virtio0"
    datastore_id = var.datastore_id
    file_format  = "raw"
    ssd          = false
    discard      = "on"
    iothread     = true
  }

  network_device {
    bridge  = "vmbr0"
    model   = "virtio"
  }

  initialization {
    datastore_id = var.datastore_id
    ip_config {
      ipv4 {
        address = each.value.address
        gateway = "${join(".", slice(split(".", each.value.address), 0, 3))}.1"
      }
    }
    dns {
      servers = [
        "9.9.9.9",
        "8.8.8.8"
      ]
    }
    user_account {
      username = each.value.username
      keys = [
        var.ssh_public_key
      ]
    }
  }
}