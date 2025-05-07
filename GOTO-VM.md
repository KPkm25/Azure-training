## Default choice for a generic VM

```
provider "azurerm" {

 features {}

}

# Define the resource group

resource "azurerm_resource_group" "example" {

 name = "parakram-tf-1"

 location = "Central India"

}

# Define the virtual network

resource "azurerm_virtual_network" "example" {

 name = "parakram-vnet-tf"

 location = azurerm_resource_group.example.location

 resource_group_name = azurerm_resource_group.example.name

 address_space = ["10.0.0.0/16"]

}

# Define the subnet

resource "azurerm_subnet" "example" {

 name = "backend-subnet"

 resource_group_name = azurerm_resource_group.example.name

 virtual_network_name = azurerm_virtual_network.example.name

 address_prefixes = ["10.0.1.0/24"]

}

# NSG for VMSS Subnet
resource "azurerm_network_security_group" "web_nsg" {
  name                = "parakram-nsg"
  location            = resource.azurerm_resource_group.example.location
  resource_group_name = resource.azurerm_resource_group.example.name
 
  security_rule {
    name                       = "Custom"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Any"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
 
resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = azurerm_subnet.example.id
  network_security_group_id = azurerm_network_security_group.web_nsg.id
}

resource "azurerm_public_ip" "example" {
  name                = "parakram-ip-vmss"
  location            = resource.azurerm_resource_group.example.location
  resource_group_name = resource.azurerm_resource_group.example.name
  allocation_method   = "Static"
  domain_name_label   = "parakramvmss"


  tags = {
    environment = "staging"
  }
}

# Define the Network Interface Card (NIC)

resource "azurerm_network_interface" "example" {

 name = "parakram-nic"

 location = azurerm_resource_group.example.location

 resource_group_name = azurerm_resource_group.example.name

 # IP configuration block

 ip_configuration {

  name = "internal"

  subnet_id = azurerm_subnet.example.id

  private_ip_address_allocation = "Dynamic"
  public_ip_address_id          = azurerm_public_ip.example.id  

 }

 tags = {

  environment = "backend"

 }

}

# Define the VM

resource "azurerm_linux_virtual_machine" "example" {

 name = "parakram-backend-vm"

 resource_group_name = azurerm_resource_group.example.name

 location = azurerm_resource_group.example.location

 size = "Standard_B1s"

 admin_username = "parakram"

 # OS disk block

 os_disk {

  name = "parakram-backend-os-disk"

  caching = "ReadWrite"

  storage_account_type = "Standard_LRS"

  disk_size_gb = 30

 }

 admin_ssh_key {

  username = "parakram"

  public_key = file("~/.ssh/id_rsa.pub") # You can generate a new SSH key if you want

 }

 # Specify the image using source_image_reference

 source_image_reference {

  publisher = "Canonical"

  offer = "0001-com-ubuntu-server-jammy"

  sku = "22_04-lts"

  version = "latest"

 }

 network_interface_ids = [azurerm_network_interface.example.id]

 tags = {

  environment = "backend"

 }

}

terraform{

 required_providers {

  azurerm = {

   source = "hashicorp/azurerm"

   version = "2.40.0"

  }

 }

}

```