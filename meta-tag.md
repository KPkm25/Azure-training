## Using the count meta-tag in terraform to create a resource group

```
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    #   version = "2.40.0" 
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
#   subscription_id = "<subscription_id>"
}

resource "azurerm_resource_group" "example1" {
  name = "parakram_count${count.index + 1}"
  location = "Central India"
  count=2
}

```
Here, terraform will automatically create multiple resource groups based on the count meta-tag