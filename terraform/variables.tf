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


