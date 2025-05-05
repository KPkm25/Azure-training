## Creating a Virtual Machine ScaleSet using Terraform
---
```
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      # version = "~> 3.70" 
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
  subscription_id = "<subscription_id>"
}

data "azurerm_resource_group" "example" {
  name = "parakram_rg"
}


resource "azurerm_virtual_network" "example" {
  name                = "parakram-vnet-vmss"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "parakram-vnet-vmss-subnet"
  resource_group_name  = data.azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "example" {
  name                = "parakram-ip-vmss"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
  allocation_method   = "Static"
  domain_name_label   = "parakramvmss"


  tags = {
    environment = "staging"
  }
}

resource "azurerm_lb" "example" {
  name                = "parakram-LB-vmss"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.example.id
  }
}

# NSG for VMSS Subnet
resource "azurerm_network_security_group" "web_nsg" {
  name                = "parakram-nsg"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
 
  security_rule {
    name                       = "AllowHTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
 
resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = azurerm_subnet.example.id
  network_security_group_id = azurerm_network_security_group.web_nsg.id
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  # resource_group_name = data.azurerm_resource_group.example.name
  loadbalancer_id = azurerm_lb.example.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_nat_pool" "lbnatpool" {
  resource_group_name            = data.azurerm_resource_group.example.name
  name                           = "ssh"
  loadbalancer_id                = azurerm_lb.example.id
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"
}

resource "azurerm_lb_probe" "example" {
  # resource_group_name = data.azurerm_resource_group.example.name

  loadbalancer_id = azurerm_lb.example.id
  name            = "http-probe"
  protocol        = "Http"
  request_path    = "/"
  port            = 80
}

resource "azurerm_lb_rule" "example" {
  loadbalancer_id                = azurerm_lb.example.id
  name                           = "http-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.bpepool.id]
  probe_id                       = azurerm_lb_probe.example.id
}

resource "azurerm_linux_virtual_machine_scale_set" "example" {
  name                = "parakram-vmss"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name

  sku            = "Standard_F2s_v2"
  instances      = 2
  admin_username = "parakram"

  disable_password_authentication = true

  admin_ssh_key {
    username   = "parakram"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  source_image_id = "/subscriptions/<subscription_id>/resourceGroups/parakram_rg/providers/Microsoft.Compute/galleries/parakram_gallery/images/parakram-LB-def/versions/0.0.1"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  network_interface {
    name    = "parakram-vmss-nic"
    primary = true

    ip_configuration {
      name      = "internal"
      subnet_id = azurerm_subnet.example.id
      load_balancer_backend_address_pool_ids = [
        azurerm_lb_backend_address_pool.bpepool.id
      ]
      load_balancer_inbound_nat_rules_ids = [
        azurerm_lb_nat_pool.lbnatpool.id
      ]
    }
  }

  upgrade_mode = "Rolling"

  health_probe_id = azurerm_lb_probe.example.id

  # security_type         = "TrustedLaunch"

  # trusted_launch {
    secure_boot_enabled   = true
    vtpm_enabled          = true
  # }

  rolling_upgrade_policy {
    max_batch_instance_percent              = 20
    max_unhealthy_instance_percent          = 20
    max_unhealthy_upgraded_instance_percent = 5
    pause_time_between_batches              = "PT0S"
  }


  tags = {
    environment = "staging"
  }
}
```
