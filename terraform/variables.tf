variable "region" {
  description = "The Azure region to deploy resources in"
  type        = string
  default     = "East US"
}

variable "rg" {
  description = "Name of the resource group for monitoring"
  type        = string
  default     = "Monitoring_Boss"
}

variable "vnet" {
  description = "Name of the virtual network"
  type        = string
  default     = "monitoring-vnet"
}

variable "ssh_public_key" {
  description = "The SSH public key to use for the VM"
  type        = string
}


# Create Terraform.tfvars to hold subscription ID and git ignore it

# moved my subscription_id and secrets over to spacelift.io :)
