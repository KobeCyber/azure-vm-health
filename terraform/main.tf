# Resource Group
resource "azurerm_resource_group" "monitoring" {
  name     = var.rg
  location = var.region
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet
  location            = var.region
  resource_group_name = var.rg
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["1.1.1.1", "8.8.8.8"]

}

#Subnet

resource "azurerm_subnet" "subnet" {
  name                 = "monitoring-subnet"
  address_prefixes     = ["10.0.1.0/24"]
  resource_group_name  = var.rg
virtual_network_name = azurerm_virtual_network.vnet.name
}

# Network Security Gtoup

resource "azurerm_network_security_group" "networksg" {
  name                = "ssh-enabled"
  location            = var.region
  resource_group_name = var.rg

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
}

#Network attachment
resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.networksg.id
}


#Network Interface Card

resource "azurerm_network_interface" "nic" {
  name                = "example-nic"
  location            = var.region
  resource_group_name = var.rg

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

#Linux VM

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "example-vm"
  location            = var.region
  resource_group_name = var.rg
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

#Storage

resource "azurerm_storage_account" "storage" {
  name                     = "kobecybertest-1"
  resource_group_name      = var.rg
  location                 = var.region
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

#Log Analytics

resource "azurerm_log_analytics_workspace" "log_a" {
  name                = "example-law"
  location            = var.region
  resource_group_name = var.rg
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

#Alerts

resource "azurerm_monitor_metric_alert" "alert" {
  name                = "cpu-alert"
  resource_group_name = var.rg
  scopes              = [azurerm_linux_virtual_machine.vm.id]
  description         = "Alert when CPU > 80%"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT5M"

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }
}

