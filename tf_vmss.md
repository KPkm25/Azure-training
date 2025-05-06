## Creating a Virtual Machine ScaleSet using Terraform
---

NAT (Network Address Translation) rules in Azure Load Balancers play a crucial role in enabling external access to individual virtual machines (VMs) or instances in a Virtual Machine Scale Set (VMSS)—especially when you don’t assign public IPs to each VM.

## ✅ Importance and Significance of NAT Rules
1. Enable Access to VMs Behind a Load Balancer
NAT rules allow external clients (like SSH or RDP users) to reach individual VMs in a VMSS or backend pool.

Without NAT rules, only the Load Balancer IP is accessible—not individual VMs.

2. Port Forwarding for Secure Access
NAT rules implement port forwarding: mapping a unique frontend port on the Load Balancer to a backend VM's port.

Example:

Public IP: 20.30.40.50

NAT Rule: 20.30.40.50:50001 → VM 1:22 (SSH)

20.30.40.50:50002 → VM 2:22

This way, you can SSH into each VM in the scale set even though they don't have public IPs.

3. Reduce Public IP Usage
Only one public IP is needed for the Load Balancer.

NAT rules allow access to many VMs through different ports, avoiding the need to assign public IPs to each VM (which costs more and increases surface area).

4. Support DevOps and Management Workflows
Enables operations like:

SSH access for configuration or debugging.

RDP access for Windows VMs.

Application-level debugging on non-standard ports.

Especially useful in scalable environments (VMSS) where VMs are dynamically created/destroyed.

5. Scales Well for Dev/Test Environments
In scenarios where you might need to frequently access different instances (for testing, updates, logs), NAT rules offer a clean and cost-effective solution.

General Benefits of NAT
1. IP Address Conservation
NAT allows multiple private IP addresses to share a single public IP.

This reduces the need for a large number of public IPv4 addresses.

2. Improved Security
Internal/private IP addresses are hidden from the outside world.

This provides a layer of obfuscation that reduces direct attacks on internal devices.

3. Enables Private Network Access to the Internet
Devices with only private IPs (e.g., 192.168.x.x, 10.x.x.x) can communicate with external networks via NAT.

4. Simplifies Network Renumbering
You can change internal IP addresses without affecting external connectivity, since NAT handles address translation.

☁️ Benefits of NAT in Cloud Environments (e.g., Azure)
1. Efficient Access to VM Scale Sets
NAT rules let you access individual VMs in a scale set using different ports on a single public IP.

2. Reduced Cost
Only one public IP address is needed for access to many VMs, saving on IP costs.

3. Simplified Configuration
Especially useful for Dev/Test environments where many VMs need temporary access.

4. Controlled Access
You can precisely control which ports and which instances are exposed externally, enhancing security.

5. Avoid Public IPs on VMs
Using NAT avoids assigning public IPs to each VM, reducing the attack surface and simplifying firewall rules.


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
