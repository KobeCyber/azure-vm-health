output "workspace_id" {
  value       = azurerm_log_analytics_workspace.monitoring.id
  description = "ID of the Log Analytics workspace"
}

output "diagnostics_setting_name" {
  value       = azurerm_monitor_diagnostic_setting.vm_diagnostics[0].name
  description = "Name of the diagnostics setting"
  condition   = var.enable_vm_diagnostics
}

output "alert_id" {
  value       = azurerm_monitor_metric_alert.cpu_alert.id
  description = "ID of the CPU usage alert"
}

output "action_group_name" {
  value       = azurerm_monitor_action_group.alerts.name
  description = "Name of the action group"
}
