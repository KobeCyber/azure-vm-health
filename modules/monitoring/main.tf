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

resource "azurerm_monitor_action_group" "alerts" {
  name                = var.action_group_name
  resource_group_name = var.resource_group_name
  short_name          = "alerts"

  email_receiver {
    name          = "email-alert"
    email_address = var.alert_email
  }
}

resource "azurerm_monitor_metric_alert" "cpu_alert" {
  name                = var.alert_name
  resource_group_name = var.resource_group_name
  scopes              = [var.vm_id]
  description         = "Alert when CPU usage is high"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT5M"

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = var.cpu_threshold
  }

  action {
    action_group_id = azurerm_monitor_action_group.alerts.id
  }
}
