resource "azurerm_log_analytics_workspace" "monitoring" {
  name                = var.workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_monitor_diagnostic_setting" "vm_diagnostics" {
  count               = var.enable_vm_diagnostics ? 1 : 0

  name                = "vm-diagnostics"
  target_resource_id  = var.vm_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.monitoring.id

  log {
    category = "Administrative"
    enabled  = true
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
