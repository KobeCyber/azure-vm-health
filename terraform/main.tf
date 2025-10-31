provider "azurerm" {
  features {}
}

module "network" {
  source                = "./modules/network"
  vnet_name             = "vm-health-vnet"
  vnet_address_space    = "10.0.0.0/16"
  subnet_name           = "vm-subnet"
  subnet_address_prefix = "10.0.1.0/24"
  nsg_name              = "vm-nsg"
  nic_name              = "vm-nic"
  location              = var.location
  resource_group_name   = var.resource_group_name
}

module "virtual_machine" {
  source              = "./modules/virtual_machine"
  vm_name             = var.vm_name
  vm_size             = var.vm_size
  location            = var.location
  resource_group_name = var.resource_group_name
  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key
  nic_id              = module.network.nic_id
}

module "monitoring" {
  source                  = "./modules/monitoring"
  workspace_name          = "vm-health-workspace"
  location                = var.location
  resource_group_name     = var.resource_group_name
  vm_id                   = module.compute.vm_id
  enable_vm_diagnostics   = true
}

resource "azurerm_resource_group" "rg" {
  name     = var.name
  location = var.location
}

