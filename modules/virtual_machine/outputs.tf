output "vm_id" {
  value       = azurerm_linux_virtual_machine.vm.id
  description = "ID of the created VM"
}

output "vm_name" {
  value       = azurerm_linux_virtual_machine.vm.name
  description = "Name of the created VM"
}
