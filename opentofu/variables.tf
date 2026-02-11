variable "virtual_environment_endpoint" {
  type        = string
  description = "Адрес конечной точки API Proxmox Virtual Environment (например: https://host:port)"
}

variable "virtual_environment_api_token" {
  type        = string
  description = "API токен для Proxmox Virtual Environment (например: root@pam!for-terraform-provider=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx)"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH публичный ключ для ВМ (например: ssh-rsa ...)"
}

variable "datastore_id" {
  type        = string
  description = "Идентификатор хранилища для размещения виртуальных машин"
}