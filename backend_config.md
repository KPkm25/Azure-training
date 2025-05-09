## Configuring backend configuration to use a specific storage account

### Create a storage account
```
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_resource_group" "tfstate" {
  name     = "parakramtfstate"
  location = "East US"
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "tfstate${random_string.resource_code.result}"
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_nested_items_to_be_public = false

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}
```

### Connecting to the newly created storage account and configuring the backend
```
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
  backend "azurerm" {
      resource_group_name  = "parakramtfstate"
      storage_account_name = "tfstatez4wc6"
      container_name       = "tfstate"
      key                  = "terraform.tfstate"
  }

}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "state-demo-secure" {
  name     = "state-demo"
  location = "eastus"
}
```

### Initialize the code again
Run `terraform init`
```
user16 [ ~/terraform/backend_config ]$ terraform init
Initializing the backend...
Acquiring state lock. This may take a few moments...
Do you want to copy existing state to the new backend?
  Pre-existing state was found while migrating the previous "local" backend to the
  newly configured "azurerm" backend. No existing state was found in the newly
  configured "azurerm" backend. Do you want to copy this state to the new "azurerm"
  backend? Enter "yes" to copy and "no" to start with an empty state.

  Enter a value: yes

Releasing state lock. This may take a few moments...

Successfully configured the backend "azurerm"! Terraform will automatically
use this backend unless the backend configuration changes.
Initializing provider plugins...
- Reusing previous version of hashicorp/azurerm from the dependency lock file
- Reusing previous version of hashicorp/random from the dependency lock file
- Using previously-installed hashicorp/azurerm v3.117.1
- Using previously-installed hashicorp/random v3.7.2

Terraform has been successfully initialized!
```

### Add the storage account to the Terraform block
```
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
    backend "azurerm" {
      resource_group_name  = "parakramtfstate"
      storage_account_name = "tfstatez4wc6"
      container_name       = "tfstate"
      key                  = "terraform.tfstate"
  }


}

provider "azurerm" {
  features {}
}

resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_resource_group" "tfstate" {
  name     = "parakramtfstate"
  location = "East US"
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "tfstate${random_string.resource_code.result}"
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_nested_items_to_be_public = false

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}
```
