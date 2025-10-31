output "resource_group_name" {
  value       = module.resource_group.resource_group_name
  description = "Name of the resource group"
}

output "vm_id" {
  value       = module.compute.vm_id
  description = "ID of the virtual machine"
}

output "nic_id" {
  value       = module.network.nic_id
  description = "ID of the network interface"
}

output "subnet_id" {
  value       = module.network.subnet_id
  description = "ID of the subnet"
}

output "workspace_id" {
  value       = module.monitoring.workspace_id
  description = "ID of the Log Analytics workspace"
}
