Using Storage Accounts for fileshare in Azure
---
Using Azure Storage Accounts for File Shares — Theoretical Guide
### 1. Understand the Goal
- You want to:
- Provision infrastructure on Azure using Terraform.
- Set up a Storage Account with a File Share (SMB protocol).
- Deploy a Linux Virtual Machine that can mount the Azure File Share.
- Securely connect the VM using SSH and access the file share like a network drive.

### 2. Key Azure Services Involved

- Resource Group:	Logical container for managing Azure resources.
- Storage Account:	Stores blobs, files, queues, and tables. Needed for file share.
- Storage File Share:	A fully managed SMB file share hosted in Azure.
- Virtual Network (VNet):	Private network for the VM.
- Subnet:	Subdivision of the VNet.
- Network Interface (NIC):	Connects the VM to the subnet.
- Public IP:	Allows external access to the VM.
- Network Security Group:	Defines firewall rules (e.g., allow SSH).
- Linux VM:	Hosts the mount point for the Azure File Share.

### 3. Design Flow (Architecture)
```
+-------------------------+
|     Resource Group      |
+-------------------------+
         |
         +--> Storage Account
         |      |
         |      +--> File Share (SMB)
         |
         +--> Virtual Network
                |
                +--> Subnet
                       |
                       +--> NIC
                             |
                             +--> Public IP
                             +--> NSG (Allow SSH)
                             |
                             +--> Linux VM
                                    |
                                    +--> Mounts File Share via SMB
```
### 4. Terraform's Role
Terraform serves as the Infrastructure as Code (IaC) tool that:

- Automates provisioning of all Azure resources.

- Defines relationships between resources (e.g., a VM in a subnet, or NSG bound to NIC).

- Ensures resources can be easily recreated, versioned, and destroyed.

### 5. Security & Access
- NSG Rule: Allow inbound SSH (port 22) to connect to the VM.

- Storage Key: Acts like a password to access the file share. Stored securely on the VM.

- Public IP: Required to connect to the VM unless using VPN or a jumpbox.

- Optional: You can further restrict access using private endpoints or limited IPs.


## Accessing the FileShare tab in Azure
- Locate the Storage Account
- Inside the resource group, locate your storage account (e.g., parakramstorage).

- Click on it to open the Storage Account Overview page.

### Step-1: Navigate to File Shares
In the left-hand menu of the Storage Account page:

- Scroll down to the "Data storage" section.

- Click on "File shares".

### Step-2: View or Create File Shares
Here, you will see a list of existing Azure File Shares (if any).

You can:

- Click on an existing file share (e.g., kpkm-file-share) to explore its contents.

- Or click “+ File share” at the top to create a new one.

### Step-3: Upload, Download, and Manage Files
Inside a file share:

- Use the toolbar to upload, download, delete, or create directories.

- You can manage access keys, SAS tokens, or connect scripts from the top menu.



---
```
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.40.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features{}
}

resource "azurerm_resource_group" "example" {
  name     = "parakram_rg_tf"
  location = "Central India"
}

resource "azurerm_storage_account" "example" {
  name                     = "parakramstorage"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "example" {
  name                  = "parakramtrial"
  storage_account_name    = azurerm_storage_account.example.name
  container_access_type = "private"
}

# resource "azurerm_storage_blob" "example" {
#   name                   = "my-awesome-content.zip"
#   storage_account_name   = azurerm_storage_account.example.name
#   storage_container_name = azurerm_storage_container.example.name
#   type                   = "Block"
#   source                 = "some-local-file.zip"
# }

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

# Define the Network Interface Card (NIC)
resource "azurerm_network_interface" "example" {
  name                = "parakram-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }

  tags = {
    environment = "backend"
  }
}



# Define the VM

resource "azurerm_linux_virtual_machine" "example1" {

 name = "parakram-tf-vm1"

 resource_group_name = azurerm_resource_group.example.name

 location = azurerm_resource_group.example.location

 size = "Standard_B1s"

 admin_username = "parakram"

 # OS disk block

 os_disk {

  name = "parakram-tf-os-disk"

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

  environment = "backend1"

 }
}


resource "azurerm_network_security_group" "example" {
  name                = "parakram-nsg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"   # restrict this to your IP for better security
    destination_address_prefix = "*"
  }

  tags = {
    environment = "backend"
  }
}

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}

resource "azurerm_public_ip" "example" {
  name                = "parakram-public-ip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"

  sku = "Basic"

  tags = {
    environment = "backend"
  }
}
```

## Script to mount the fileshare to the Linux VM
```
sudo mkdir -p /home/kpkm-file-share
if [ ! -d "/etc/smbcredentials" ]; then
sudo mkdir /etc/smbcredentials
fi
if [ ! -f "/etc/smbcredentials/parakramstorage.cred" ]; then
    sudo bash -c 'echo "username=parakramstorage" >> /etc/smbcredentials/parakramstorage.cred'
    sudo bash -c 'echo "password=*************==" >> /etc/smbcredentials/parakramstorage.cred'
fi
sudo chmod 600 /etc/smbcredentials/parakramstorage.cred

sudo bash -c 'echo "//parakramstorage.file.core.windows.net/kpkm-file-share /home/kpkm-file-share cifs nofail,credentials=/etc/smbcredentials/parakramstorage.cred,dir_mode=0755,file_mode=0755,serverino,nosharesock,mfsymlinks,actimeo=30" >> /etc/fstab'
sudo mount -t cifs //parakramstorage.file.core.windows.net/kpkm-file-share /home/kpkm-file-share -o credentials=/etc/smbcredentials/parakramstorage.cred,dir_mode=0755,file_mode=0755,serverino,nosharesock,mfsymlinks,actimeo=30
```