**22-04-25**

## Types of Scaling in Kubernetes

**-  Horizontal scaling/Horizontal Pod Autoscaler (HPA):** This feature can effortlessly add or release pod replicas automatically.

**-  Vertical scaling/Vertical Pod Autoscaler (VPA):** This feature in which CPU and memory reservations adjust automatically.

**-  Cluster Autoscaler:** In this feature an analysis of resources occurs, and we make essential adjustments in the deployment and handle the load.(similar to horizontal scaling)

---

## Non-functional requirements:

Non-functional requirements in software engineering refer to the characteristics of a software system that are not related to specific functionality or behavior. They describe how the system should perform, rather than what it should do. 

Examples of NFR:
-  Availability, scalability, performance, agility, security, consistency, reliability, durability

*Strategy is a long term plan while tactics are the short term plan to achieve a certain outcome*

---

## SaaS:

**Characteristics:**
-  Web based access
-  Centralised hosting
-  Subscription based pricing

**Benefits:**
-  Lower upfront cost
-  Reduced IT Overhead
-  Faster implementation
-  Automatic updates and maintenance
-  Scalability and Flexibility
-  Accessibility
-  Predictable costs



## VNET:
A Virtual Network (VNET) in Azure is a private, isolated network environment where you can securely run your virtual machines, containers, databases, and services.
It’s basically your own custom network inside the cloud, similar to a traditional on-premises network — but fully virtual.

When you create a VNET, you must define an IP address space using CIDR notation (e.g., 10.0.0.0/16).

This IP space is then divided into subnets (e.g., 10.0.1.0/24, 10.0.2.0/24).

Resources like VMs and containers are assigned IPs from these subnets.
VNETs in the same or different regions can be connected via VNET Peering.

```
┌────────────┐
│   VNET     │  ← Your cloud-based private network (e.g., 10.0.0.0/16)
│            │
│ ┌────────┐ │
│ │Subnet1 │ ← E.g., 10.0.1.0/24 – Public subnet
│ │  VM1   │
│ └────────┘ │
│ ┌────────┐ │
│ │Subnet2 │ ← E.g., 10.0.2.0/24 – Private subnet
│ │  VM2   │
│ └────────┘ │
└────────────┘

```

VPC/VNET peering (advantage and uses)- security, latency and cost


**Bastion Host:**

A Bastion Host is a highly secure virtual machine that acts as a gateway to access private resources (like VMs in a private subnet) without exposing them to the public internet.

A bastion host is a dedicated server designed to withstand cyberattacks and provide secure access to a private network from an untrusted source, such as the Internet.

It’s your "single door" into a secure network.

```

Internet
   ↓
[Bastion Host] ← Public Subnet, has public IP
   ↓
[Private VM] ← Private Subnet, no public IP

```

public/private subnets ->  VNET ->  availability zones ->  subnets

Connecting to the Azure VM
-  Start the Cloud shell and upload the .pem file
-  Check the .pem file permissions by running the command ls -ltr
-  Change the file permission by running the cmd, `chmod 400 <pem file name> `
-  Connect to the instance via ssh using the command, `ssh -i <pem filename>  <username> @<publicIP> `
 example: `ssh -i parakram-vm01_key.pem parakram@74.224.99.200`

---

**23-04-25**

-  VNETS are region scoped

-  VM must be in a Subnet, which belongs to a VNET, which is in a Region, optionally inside an Availability Zone.


**Creating subnets**


| n/w bits | 1 | 2 | 4 | 8 | 16 | 32 | 64 | 128 | 256 |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| hosts | 256 | 128 | 64 | 32 | 16 | 8 | 4 | 2 | 1 |
| subnet | /24 | /25 | /26 | /27 | /28 | /29 | /30 | /31 | /32 |


`Total range: 10.0.0.0/24 =>  32-24=> 2^8=> 10.0.0.0 - 10.0.0.256`

| Range | IP Range | Network ID | Broadcast IP | CIDR |
|:---|:---|:---|:---|:---|
| First range | 10.0.0.1 - 10.0.0.62 | 10.0.0.0 | 10.0.0.63 | 10.0.0.0/26 |
| Second range | 10.0.0.65 - 10.0.0.126 | 10.0.0.64 | 10.0.0.127 | 10.0.0.64/26 |
| Third range | 10.0.0.129 -10.0.0.190 |	10.0.0.128 |		10.0.0.191 |		10.0.0.128/26 |


---

**24-04-25**

## Create New User in Azure
-  Go to Microsoft Entra ID -  Manage -  Users
-  Click on Create New User
-  Add the username and set password
-  In the role assignments, select Add Group and add AzureGroup(gives all necessary permissions to its members)
-  Finalize and create the user
-  When logging in for the first time, you will be prompted to reset the password.

## Granting access to users:
-  Go to Subscription ->  MML/create new subscription if not exist ->  Access Control(IAM) ->  Add ->  Add Role Assignment
-  New roles can be created or assigned to different users/groups

## Adjusting Quotas
-  Go to Quotas ->  Settings ->  My Quotas
-  Check the limit for your preferred resources(Regional vCPUs, availability sets, DSv3 Family vCPUs etc)
-  We can adjust the quota according to our requirements.

## Cloud Deployment Models:

**-  Public:** Shared resources, Minimal Investment,No setup cost,Infrastructure Management is not required, No maintenance, Dynamic Scalability
Disadvantages: Less secure, security concerns, vendor lock-in, compliance, cost management
Used for web hosting, Software development and deployment, SaaS applications.

**-  Private:** Better Control,Data Security and Privacy,Supports Legacy Systems,Customization,Less scalable,Costly, 

**-  Hybrid:** Flexibility and control,Cost,Security,Difficult to manage,Slow data transmission


## Azure Global Infrastructure:

-  Availability Zones
-  Data Centers
-  Region Pairs
-  Azure Global Network

Characteristics and Benefits:
-  Global reach
-  High Availability and Resiliency
-  Scalability and flexibility
-  Security
-  Compliance and Data residency
-  Sustainability

## Azure Edge Zone:
 An Azure Edge Zone is a local extension of Azure that brings compute, storage, and networking services closer to where data is generated or consumed — often in metro areas, at telecom operator facilities, or even on customer premises. It’s designed to support low-latency and high-throughput applications, like real-time analytics, gaming, IoT, and AR/VR. Running AR/VR experiences in real time, Hosting multiplayer game logic close to gamers, Processing video feeds on-site for a smart factory, Delivering AI results within milliseconds on local machines

**Key Benefits**
Low Latency: Closer proximity = faster response times (often <10ms).

Data Sovereignty: Data can stay within local regions or even onsite.

Scalability: Use Azure tools to scale workloads up or down.

Consistency: Same APIs, tools, and management as global Azure.

## Cloud CDN:
A Cloud CDN (Content Delivery Network) is a globally distributed network of servers that caches and delivers web content (like images, videos, CSS/JS files, or even APIs) closer to users to improve performance, reliability, and scalability. These edge servers store copies of static assets like images, videos, CSS, JavaScript files, or even full HTML pages.


Hierarchy in Azure:

`Account ->  subscription ->  entra id ->  tenant`

**Assignment:**
VIII. Role-Based Access Control (RBAC) Labs:

Assign Built-in Roles at Different Scopes:

 Navigate to a Subscription, Resource Group, or a specific resource (e.g., a Storage Account).

 Assign the "Reader" role to a test user at the Subscription level.

 Verify the user can view resources in all Resource Groups within the Subscription but cannot make changes.

 Assign the "Contributor" role to the same test user at a specific Resource Group level.

 Verify the user can now create and manage resources within that specific Resource Group.

 Assign the "Storage Blob Data Reader" role to the same test user on a specific Storage Account. Verify the user can only read data from blobs in that Storage Account.

 Remove all role assignments for the test user.

 Assign "Reader" role to a user at resource group level.

 Verify the user is not getting access outside the resource group.

---

**25-04-25**

## Azure Hierarchy

```

Account ->  Tenant(isolated, shared space in the Azure cloud. Can be multiple) ->  Management groups(can be multiple, handles the subscriptions) -> Subscriptions(can be multiple, handles the payments) ->  resource group (collection of resources for easier access and subscription) ->  resources(each individual service in the cloud)

```

Role is assigned to an identity, identity can contain users, groups and service principle(gives access to a certain service)

User management  and permissions to manage users are different things and not resources, but both are done via EntraID.

Active Directory(AD) services were integrated with Azure EntraID for IAM.

## ACID Properties:

ACID properties in DBMS stand for Atomicity, Consistency, Isolation, and Durability, and they are fundamental to ensuring the reliable execution of database transactions. These properties guarantee that database transactions are processed accurately and predictably, even in the face of errors or system failures. 
Here's a breakdown of each property:

**Atomicity:**
A transaction is treated as an indivisible unit of work. Either all operations within the transaction complete successfully, or none of them are applied, ensuring data integrity. 

**Consistency:**
Transactions maintain the database in a valid state. This means that the database rules and constraints are enforced, ensuring that the data remains accurate and reliable after the transaction. 

**Isolation:**
Transactions are isolated from each other, meaning that one transaction cannot interfere with or see the intermediate changes made by another transaction until it is committed. 

**Durability:**
Once a transaction is committed, its changes are permanently stored in the database and will persist even in the event of system failures. 

*Eventual consistency is a consistency model in distributed systems where, after a period of time with no new updates, all data replicas will eventually converge to the same value. This allows for temporary inconsistencies in data between replicas, enabling high availability and partition tolerance.*
*Ex: WhatsApp demonstrates Eventual consistency while phone calls show immediate consistency.*
*Similar to asynchronous operations, we can do something else while the asynchronous/eventual consistency operation is taking place.* 

---

## CLI COMMANDS:
```

 🔐 Login and Subscription
az login =>  Sign in to your Azure account
az account list =>  List all Azure subscriptions
az account set --subscription <SUBSCRIPTION>  => Set the active subscription

 ⚙️ Configuration
az config set defaults.location="East US 2"  =>  Set default region
az config set defaults.group="parakram_rg_eastus"  => Set default resource group
az config get defaults =>  View default CLI settings
az show config =>  Show full config details

 🗂️ Resource Group
az group create --name <name>  --location <location>  =>  Create a resource group
az group list =>   List all resource groups
az group delete --name <name>  =>  Delete a specific resource group

 📦 Storage Account
az storage account list =>  List all storage accounts
az storage account show --name <name>  --resource-group <rg>  =>  Show details of a storage account

 🖥️ Virtual Machines
az vm list =>  List all virtual machines
az vm list --query "[].name" --output tsv =>  List only VM names
az vm list-skus --location <location>  =>  List VM sizes available in a region
az vm delete --name <vm>  --resource-group <rg>  =>  Delete a VM

```

## POWERSHELL COMMANDS:
```

 🔐 Login and Subscription
Connect-AzAccount =>  Sign in to Azure
Connect-AzAccount -UseDeviceAuthentication =>  Device-based login method
Get-AzSubscription =>  List all Azure subscriptions
Set-AzContext -Subscription <SUBSCRIPTION>  =>  Set active subscription
Get-AzAccount =>  View signed-in account
Get-AzContext =>  View current subscription and defaults

 🗂️ Resource Group
Get-AzResourceGroup =>  List all resource groups
Get-AzResourceGroup -Location eastus2 =>  Filter by location
Get-AzResourceGroup -Name parakram_rg_eastus =>  Get details of a specific group
Remove-AzResourceGroup -Name <name>  =>  Delete a resource group

 📦 Storage Account
Get-AzStorageAccount =>  List all storage accounts
Get-AzStorageAccount -Name <name>  -ResourceGroupName <rg>  =>  Show storage account details

 🖥️ Virtual Machines
Get-AzVM =>  List all virtual machines
Get-AzVM -Name <vm-name>  =>  Get details of a specific VM
Remove-AzVM -ResourceGroupName <rg>  -Name <vm-name>  =>  Delete a VM
New-AzVM -Name <name>  =>  Create a new VM (with default config)
Set-AzVM -ResourceGroupName <rg>  -Name <vm>  =>  Modify VM config
Set-AzVM -ResourceGroupName <rg>  -Name <vm>  -Generalized =>  Mark VM as generalized

```
---

Managed identities!
What is a Runbook


## Azure Functions:
- Serverless compute service that lets you run event-triggered code without having to explicitly specify the infrastructure.
- Allows to run small pieces of code(functions) without worrying about application infrastructure
**Features:**
- serverless application
- choice of language
-  pay per use pricing model
- bring your own dependencies
- integrated security
- simplified integration
- flexible development

**Uses:**
- Processing bulk data, integrating systems, working with IoT and building simple API's and microservices.

---

**28-04-25**

## Infrastructure as Code(IAC):
In simple words, it means managing and setting up your IT infrastructure (like servers, networks, databases, etc.) using code instead of doing it manually.

**Why people love IaC:**
- Speed (build infrastructure fast)
- Consistency (no "it works on my machine" problems)
- Version control (infrastructure changes are tracked in Git)
- Automation (less human error)
- Reusable code

**3 forms of IAC:**
-  Infrastructure Provisioning(Azure ARM templates, Azure BICEP, Terraform, AWS Boto, Cloud Formation)
-  Config mgmt. tool(Ansible, Puppet, Chef= check differences!!)
-  Server Templating(Vagrant and Docker)

## Creating a VM and accessing it
```
user16 [ ~ ]$ az vm create \
 --resource-group parakram_rg \
 --name parakramVM \
 --image Ubuntu2204 \
 --size Standard_B1s \
 --admin-username parakram \
 --generate-ssh-keys \
 --vnet-name kpkm_vnet \
 --subnet kpkm_subnet \
 --location centralindia

 SSH into it:
 ssh parakram@4.240.54.242

```

## Installing Terraform
```
sudo su

sudo apt update

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

apt-cache policy azure-cli

az login

terraform -help

sudo apt-get update && sudo apt-get install -y gnupg software-properties-common

wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

sudo wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

sudo gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update

sudo apt-get install terraform

terraform -help

terraform -version


```

## Terraform basics(commands and files)

| Command / File | One-Line Definition |
|:---|:---|
| `terraform init` | Initializes the Terraform project by downloading necessary provider plugins. |
| `terraform plan` | Creates an execution plan showing what Terraform will do without making changes. |
| `terraform apply` | Applies the planned changes and provisions or updates the infrastructure. |
| `cat terraform.tfstate` | Displays the Terraform state file, which tracks the real infrastructure and resource IDs. |
| `terraform destroy` | Destroys all infrastructure managed by Terraform (teardown everything). |
| `cat main.tf` | Displays the contents of `main.tf`, your main Terraform configuration file. |
| `terraform fmt` | Formats Terraform configuration files (`.tf`) to make them clean and standardized. |
| `terraform validate` | Validates whether your Terraform configuration files are syntactically correct. |

---

**30-04-25**

## Terraform
Terraform is an open-source Infrastructure-as-Code (IaC) tool created by HashiCorp. It allows users to define and provision infrastructure using a declarative configuration language, typically HashiCorp Configuration Language (HCL) or JSON. Terraform enables the management of infrastructure across various platforms, including public clouds, private clouds, and SaaS services, through the use of providers, which are plugins that enable Terraform to interact with specific platforms or services. 
Here's a more detailed explanation:

## Key Features and Concepts:
**Infrastructure as Code:**
Terraform treats infrastructure as code, meaning that it defines the desired state of infrastructure resources in configuration files. This allows for version control, collaboration, and automation of infrastructure provisioning and management. 
**Declarative Language:**
Terraform uses a declarative language, meaning that users describe the desired end state of their infrastructure, and Terraform automatically manages the process of achieving that state. This contrasts with procedural languages where users must explicitly define the steps required to create and manage infrastructure. 
**Providers:**
Terraform uses providers to interact with specific infrastructure platforms or services. These providers enable Terraform to create, update, and delete resources within those platforms. 
**Workflows:**
Terraform follows a consistent workflow for managing infrastructure: 
- Writing Code: Users define their infrastructure in configuration files. 
- Planning: Terraform analyzes the configuration and creates an execution plan, showing how the infrastructure will be updated. 
- Applying: Terraform executes the plan, provisioning or modifying the infrastructure as needed. 
- Destroying: Terraform can also destroy existing infrastructure resources. 
**Modules:**
Terraform modules allow users to package and reuse infrastructure configurations, promoting reusability and maintainability. 
**State Management:**
Terraform maintains a state file that tracks the current state of the infrastructure resources. This state file is used to determine what changes are needed to achieve the desired state. 

**Adv. of Terraform**
-	Does orchestration, not just configuration management
-	Supports multiple providers such as AWS, Azure, GCP, DigitalOcean and many more
-	Provide immutable infrastructure where configuration changes smoothly
-	Uses easy to understand language, HCL (HashiCorp configuration language)
-	Easily portable to any other provider
-	Supports Client only architecture, so no need for additional configuration management on a server

## CI/CD for terraform
- CI (Continuous Integration): Automatically test and validate Terraform code (e.g., terraform validate, terraform fmt, terraform plan) whenever changes are made—typically via pull requests.

- CD (Continuous Deployment/Delivery): Automatically apply the approved Terraform changes (e.g., terraform apply) to target environments like staging or production, often with safeguards like manual approval steps.

**Advantages**
- Automated Validation and Testing
- Consistency and Repeatability
- Safer Infrastructure Changes
- Better Security and Compliance
- Faster Feedback Loop
- Reduced Downtime and Human Intervention
- Scalability and Collaboration

## Policy as a Code
Policy as Code (PaC) is the practice of writing and enforcing infrastructure and security policies using machine-readable code, rather than manual processes or documentation. It ensures that rules, compliance requirements, and governance controls are automatically applied to infrastructure and applications during deployment.

### Why Policy as Code?
✅ Automated Compliance: Prevents misconfigurations before they reach production.

🧪 Prevention > Detection: Enforce policies during CI/CD (e.g., block insecure Terraform code).

🔁 Version Control: Policies live in Git like the rest of the codebase.

🔐 Security & Governance: Automatically enforce least privilege, encryption, tagging, etc.

---
### Required_Providers
In Terraform, the required_providers block specifies which providers your configuration depends on and their minimum required versions. This block lives inside the terraform block at the top of your configuration file (usually main.tf or provider.tf).

**📦 Purpose of required_providers**
- Declares dependencies on external providers (like AWS, Azure, Google Cloud, etc.).
- Ensures consistent and controlled versions of providers across environments.
- Enables Terraform to automatically download the correct version from the Terraform Registry or other sources.

```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" // ~> means update till the latest patch/minor version, from 5.0.0 till < 6.0
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
  }

  required_version = ">= 1.4.0"
}

```
### Release Versioning
| Component | Example | Purpose |
|----------|---------|---------|
| **MAJOR** | `2.x.x` | Introduces **breaking changes**; incompatible with previous versions. |
| **MINOR** | `1.3.x` | Adds **new features** without breaking backward compatibility. |
| **PATCH** | `1.2.5` | Includes **bug fixes** or small improvements; fully backward compatible. |

***Hot fixes: Changes made in 24 hours or less after release***

## Terraform State
Terraform state is a file that tracks the current state of your infrastructure as Terraform understands it. It acts as the single source of truth for Terraform to know what resources it has created, updated, or deleted.

**📦 Key Purposes of Terraform State**
- Mapping: Matches Terraform configuration to real-world infrastructure.
- Tracking Metadata: Stores resource IDs, dependencies, and values.
- Performance: Speeds up operations by caching resource information.
- Change Detection: Enables terraform plan to detect what’s changing.

### terraform.tfstate
When multiple people work on the same Terraform project, the terraform.tfstate file plays a critical role — and it must be carefully managed to avoid conflicts, data loss, or infrastructure drift.
Terraform maintains a snapshot of infrastructure in terraform.tfstate. Every time someone runs:

- `terraform plan`: it compares the current state file to your configuration.
- `terraform apply`: it updates real infrastructure and the state file.

If two people use the same code but different versions of the state file, they can overwrite or undo each other's changes, leading to serious issues.

**❌ Problems with Local State in Team Environments**
- Race conditions: Two users run apply at the same time → state gets corrupted.
- No locking: No mechanism to prevent concurrent writes.
- Manual sync: Team members need to send .tfstate file around — error-prone.

**✅ Recommended Approach: Use a Remote Backend with Locking**
To safely collaborate on Terraform code, use a remote backend that supports:

- State sharing: All users reference the same remote tfstate.
- State locking: Prevents multiple apply operations at the same time.
- Versioning: Roll back to previous states if something breaks.

**🛠 Workflow with Remote State**
- Developer A runs terraform apply
- Acquires lock
- Updates resources and state
- Releases lock
- Developer B tries to run apply
- Sees: Error: state is locked by another user
- Waits or stops

```
provider "azurerm" {

 features {}

}
terraform{

 required_providers {

  azurerm = {

   source = "hashicorp/azurerm"

   version = "~>2.0" //download the latest version in the 2.x series

  }

 }
}
```
***Note: If there are previously installed versions of Tf, we might have to remove all .tf files and reinitilize using `terraform init` ***

If we want to jump to a major upgrade, we'll get an error unless specified otherwise:
```
 Error: Failed to query available provider packages
│ 
│ Could not retrieve the list of available versions for provider hashicorp/azurerm: locked provider registry.terraform.io/hashicorp/azurerm
│ 2.99.0 does not match configured version constraint ~> 3.0; must use terraform init -upgrade to allow selection of new versions
```

Similarly, changing the version of Terraform itself might throw some errors if there's a chance for breaking changes
```
│ Error: Unsupported Terraform Core version
│ 
│   on main.tf line 19, in terraform:
│   19:  required_version = "<=1.0"
│ 
│ This configuration does not support Terraform version 1.11.2. To proceed, either choose another supported Terraform version or update this
│ version constraint. Version constraints are normally set for good reason, so updating the constraint may lead to other errors or unexpected
│ behavior.
```

## Code to create a virtual network in an existing resource group
```
provider "azurerm" {

 features {}

}
terraform{

 required_providers {

  azurerm = {

   source = "hashicorp/azurerm"

   version = "~>3.0"

  }

 }
}

data "azurerm_resource_group" "example"{
    name="parakram_rg"
}

output "id" {
    value = data.azurerm_resource_group.example.id
}

output "name" {
    value = resource.azurerm_virtual_network.example.name
}

resource "azurerm_virtual_network" "example"{
 name   ="example_nw"
 location       = data.azurerm_resource_group.example.location
 resource_group_name    = data.azurerm_resource_group.example.name
 address_space  =["10.0.0.0/16"]
 
}
```
---

## Code blocks in Terraform

- `provider` block: Declares the cloud provider (Azure in this case) and configures its settings.
- `terraform`block: Configures Terraform-specific settings. Declares required provider versions and their sources.
- `data` block: Defines a data source to fetch existing infrastructure information (like an existing Azure resource group). Used for read-only lookup.
- `output` blocks: Used to display values after Terraform runs (e.g., resource IDs, names). Helpful for debugging or passing values to other modules.
- `resource` block: Defines new infrastructure to be created and managed by Terraform (an Azure virtual network here).

**depends_on**
The depends_on meta-argument instructs Terraform to complete all actions on the dependency object (including Read actions) before performing actions on the object declaring the dependency.
You can use the depends_on meta-argument in module blocks and in all resource blocks, regardless of resource type. It requires a list of references to other resources or child modules in the same calling module.

```
resource "azurerm_linux_virtual_machine" "example2" {

 name = "parakram-tf-vm2"

 resource_group_name = azurerm_resource_group.example.name

 location = azurerm_resource_group.example.location

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
```

---

## Security in CLoud

1. Defence in depth
2. Layered Security
** 4C's in security

-> Conditional Access Policies (For authentication and authorization)

-> Statefull/stateless and persistence. Externalize the data.
-> 3 Axis of scalabilities
-> API Gateways

