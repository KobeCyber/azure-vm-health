# Resource Group
resource "azurerm_resource_group" "monitoring" {
  name     = var.rg
  location = var.region
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet
  location            = var.region
  resource_group_name = azurerm_resource_group.monitoring.name
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
  resource_group_name = azurerm_resource_group.monitoring.name

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

# Public IP for VM

resource "azurerm_public_ip" "public_ip" {
  name                = "vm-public-ip"
  location            = var.region
  resource_group_name = azurerm_resource_group.monitoring.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

#Network Interface Card

resource "azurerm_network_interface" "nic" {
  name                = "example-nic"
  location            = var.region
  resource_group_name = azurerm_resource_group.monitoring.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

#Linux Virtual Machine - Ubuntu

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "example-vm"
  location            = var.region
  resource_group_name = azurerm_resource_group.monitoring.name
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
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

#Log Analytics

resource "azurerm_log_analytics_workspace" "log_a" {
  name                = "example-law"
  location            = var.region
  resource_group_name = azurerm_resource_group.monitoring.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Data Collection Rule (DCR)
resource "azurerm_monitor_data_collection_rule" "linux_dcr" {
  name                = "linux-monitoring-dcr"
  location            = var.region
  resource_group_name = azurerm_resource_group.monitoring.name

  destinations {
    log_analytics {
      name                  = "default-destination"
      workspace_resource_id  = azurerm_log_analytics_workspace.log_a.id
    }
  }

  data_flow {
    streams      = ["Microsoft-InsightsMetrics"]
    destinations = ["default-destination"]
  }

  data_sources {
    performance_counter {
      name                          = "linux-perf"
      streams                       = ["Microsoft-InsightsMetrics"]
      sampling_frequency_in_seconds = 60
      counter_specifiers             = ["\\Processor(_Total)\\% Processor Time"]
    }
  }
}

# Data Collection Rule Association (VM + DCR)
resource "azurerm_monitor_data_collection_rule_association" "vm_assoc" {
  name                    = "vm-dcra"
  target_resource_id      = azurerm_linux_virtual_machine.vm.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.linux_dcr.id
}


#Storage

resource "azurerm_storage_account" "storage" {
  name                     = "kobecybertest1"
  resource_group_name      = azurerm_resource_group.monitoring.name
  location                 = var.region
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


#Alerts

resource "azurerm_monitor_metric_alert" "alert" {
  name                = "cpu-alert"
  resource_group_name = azurerm_resource_group.monitoring.name
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

