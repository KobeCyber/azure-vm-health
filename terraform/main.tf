resource "azurerm_resource_group" "monitoring" {
  name     = "Monitoring_Boss"
  location = "East US"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "monitoring-vnet"
  location            = azurerm_resource_group.monitoring.location
  resource_group_name = azurerm_resource_group.monitoring.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["1.1.1.1", "8.8.8.8"]

}

resource "azurerm_subnet" "subnet" {
  name                 = "monitoring-subnet"
  address_prefixes     = ["10.0.1.0/24"]
  resource_group_name  = azurerm_resource_group.monitoring.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_network_security_group" "_nsg" {
name = "monitoring-nsg"
resource_group_name = azurerm_resourcegroup.monitoring.name

}
