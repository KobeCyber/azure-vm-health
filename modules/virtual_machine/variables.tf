variable "vm_name" {
  type        = string
  description = "Name of the virtual machine"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "vm_size" {
  type        = string
  description = "Size of the VM"
}

variable "admin_username" {
  type        = string
  description = "Admin username for the VM"
}

variable "nic_id" {
  type        = string
  description = "Network Interface ID"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for authentication"
}
