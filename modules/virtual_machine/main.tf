resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [var.nic_id]
  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }
}
