output "workspace_id" {
  value       = azurerm_log_analytics_workspace.monitoring.id
  description = "ID of the Log Analytics workspace"
}

output "diagnostics_setting_name" {
  value       = azurerm_monitor_diagnostic_setting.vm_diagnostics[0].name
  description = "Name of the diagnostics setting"
  condition   = var.enable_vm_diagnostics
}
