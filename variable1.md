## Using variables in Terraform

### main.tf
```
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
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
  name     = "my-rg${var.name}"
  location = "Central India"
}

output "name"{
  value = azurerm_resource_group.example1.name
}

```
### variables.tf
```
variable "name" {
  type    = string
  # default = "foo"
  description="Enter the resource group name:"
}
```

### terraform.tfvars
```
name = "vars-trial"
```

Here, we don't provide a default value to the "name" variable, normally this would lead to Terraform asking us for input for the "name" variable. However, in this case, the value of the variable will be automatically fetched from the terraform.tfvars file, overriding any default value present.