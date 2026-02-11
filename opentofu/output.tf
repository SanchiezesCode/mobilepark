output "vm_info" {
  description = "Имена и IP-адреса созданных виртуальных машин"
  value = {
    for vm in var.vms :
    vm.name => try(proxmox_virtual_environment_vm.vm[vm.name].ipv4_addresses[1], "нет IP")
  }
}