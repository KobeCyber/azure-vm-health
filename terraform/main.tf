resource "azurerm_resource_group" "monitoring" {
name = "Monitoring_Boss"
location = "East US"
}
resource "azurerm_virtual_network" "vnet" {}
resource "azurerm_subnet" "subnet" {}
resource "azurerm_network_security_group" "_nsg" {}
resource "azurerm_network_interface" "nic" {}
resource "azurerm_linux_virtual_machine" "vm" {}
resource "azurerm_storage_account" "storage" {}
resource "azurerm_log_analytics_workspace" "log_a" {}
resource "azurerm_monitor_metric_alert" "alert" {}
