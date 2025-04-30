Creating multiple VMs in different regions
---
provider "azurerm" {

 features {}

}

provider "azurerm" {


 alias = "Secondary"
 features {}

}

# Define the resource group

resource "azurerm_resource_group" "example" {

 name = "parakram-rg-tf"

 location = "East US"

}

# Define the virtual network for VM1

resource "azurerm_virtual_network" "example1" {

 name = "parakram-vnet-tf1"

 location = "centralindia"

 resource_group_name = azurerm_resource_group.example.name

 address_space = ["10.0.0.0/16"]

}

# Define the virtual network for VM2

resource "azurerm_virtual_network" "example2" {

 name = "parakram-vnet-tf2"

 location = "eastus"

 resource_group_name = azurerm_resource_group.example.name

 address_space = ["10.1.0.0/16"]

}

# Define the subnet for VM1

resource "azurerm_subnet" "example1" {

 name = "backend-subnet1"

 resource_group_name = azurerm_resource_group.example.name

 virtual_network_name = azurerm_virtual_network.example1.name

 address_prefixes = ["10.0.1.0/24"]

}
# Define the subnet for VM2

resource "azurerm_subnet" "example2" {

 name = "backend-subnet2"

 resource_group_name = azurerm_resource_group.example.name

 virtual_network_name = azurerm_virtual_network.example2.name

 address_prefixes = ["10.1.1.0/24"]

}

# Define the Network Interface Card for VM1 (NIC)

resource "azurerm_network_interface" "example1" {

 name = "parakram-nic"

 location = azurerm_virtual_network.example1.location

 resource_group_name = azurerm_resource_group.example.name

 # IP configuration block

 ip_configuration {

  name = "internal"

  subnet_id = azurerm_subnet.example1.id

  private_ip_address_allocation = "Dynamic"

 }

 tags = {

  environment = "backend"

 }

}
#NIC-2
resource "azurerm_network_interface" "example2" {
  name                = "parakram-nic-2"
  location            = azurerm_virtual_network.example2.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example2.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "backend"
  }
}


# Define the VM

resource "azurerm_linux_virtual_machine" "example1" {

 name = "parakram-tf-vm1"

 resource_group_name = azurerm_resource_group.example.name

 location = azurerm_virtual_network.example1.location

 size = "Standard_B1s"

 admin_username = "parakram"

 # OS disk block

 os_disk {

  name = "parakram-tf-os-disk1"

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

 network_interface_ids = [azurerm_network_interface.example1.id]

 tags = {

  environment = "backend1"

 }

}

resource "azurerm_linux_virtual_machine" "example2" {

 name = "parakram-tf-vm2"

 resource_group_name = azurerm_resource_group.example.name

 location = azurerm_virtual_network.example2.location

 size = "Standard_B1s"

 admin_username = "parakram"

 # OS disk block

 os_disk {

  name = "parakram-tf-os-disk2"

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

 network_interface_ids = [azurerm_network_interface.example2.id]
 depends_on=[azurerm_linux_virtual_machine.example1]

 tags = {

  environment = "backend2"

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



