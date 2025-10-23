resource "azurerm_resource_group" "monitoring" {
  name     = "Monitoring_Boss"
  location = var.region
}

resource "azurerm_virtual_network" "vnet" {
  name                = "monitoring-vnet"
  location            = var.region
  resource_group_name = var.rg
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["1.1.1.1", "8.8.8.8"]

}

resource "azurerm_subnet" "subnet" {
  name                 = "monitoring-subnet"
  address_prefixes     = ["10.0.1.0/24"]
  resource_group_name  = var.rg
  virtual_network_name = var.vnet
}

resource "azurerm_network_security_group" "nsg" {
name = "monitoring-nsg"
resource_group_name = var.rg

}

resource "azurerm_network_security_group" "monitoring-ssh" {
  name                = "ssh-enabled"
  location            = azurerm_resource_group.montioring.name
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
