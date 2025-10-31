variable "location" {
  type        = string
  default     = "East US"
  description = "Azure region for all resources"
}

variable "resource_group_name" {
  type        = string
  default     = "vm-health-rg"
  description = "Name of the resource group"
}

variable "vm_name" {
  type        = string
  default     = "vm-health"
  description = "Name of the virtual machine"
}

variable "vm_size" {
  type        = string
  default     = "Standard_B2s"
  description = "Size of the virtual machine"
}

variable "admin_username" {
  type        = string
  default     = "azureuser"
  description = "Admin username for the VM"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for VM access"
}

