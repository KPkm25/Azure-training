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

public/private subnets -  VNET -  availability zones -  subnets

Connecting to the Azure VM
-  Start the Cloud shell and upload the .pem file
-  Check the .pem file permissions by running the command ls -ltr
-  Change the file permission by running the cmd, `chmod 400 <pem file name `
-  Connect to the instance via ssh using the command, `ssh -i <pem filename  <username @<publicIP `
 example: `ssh -i parakram-vm01_key.pem parakram@74.224.99.200`

---

**23-04-25**

-  VNETS are region scoped

-  VM must be in a Subnet, which belongs to a VNET, which is in a Region, optionally inside an Availability Zone.


**Creating subnets**

```

n/w	1	2	4	8	16	32	64	128	256
host    256	128	64	32	16	8	4	2	1
subnet  /24	/25	/26	/27	/28	/29	/30	/31	/32

Total range: 10.0.0.0/24 =  32-24=2^8= 10.0.0.0 - 10.0.0.256

		IP range		Network ID		Broadcast IP		Range
First range:    10.0.0.1-10.0.0.62	10.0.0.0		10.0.0.63		10.0.0.0/26

2nd range:      10.0.0.65-10.0.0.126	10.0.0.64		10.0.0.127		10.0.0.64/26

3rd range:      10.0.0.129-10.0.0.190	10.0.0.128		10.0.0.191		10.0.0.128/26

```
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
-  Go to Subscription -  MML/create new subscription if not exist -  Access Control(IAM) -  Add -  Add Role Assignment
-  New roles can be created or assigned to different users/groups

## Adjusting Quotas
-  Go to Quotas -  Settings -  My Quotas
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

`Account -  subscription -  entra id -  tenant`

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

Account -  Tenant(isolated, shared space in the Azure cloud. Can be multiple) -  Management groups(can be multiple, handles the subscriptions) - Subscriptions(can be multiple, handles the payments) -  resource group (collection of resources for easier access and subscription) -  resources(each individual service in the cloud)

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
az login =  Sign in to your Azure account
az account list =  List all Azure subscriptions
az account set --subscription <SUBSCRIPTION  = Set the active subscription

 ⚙️ Configuration
az config set defaults.location="East US 2"  =  Set default region
az config set defaults.group="parakram_rg_eastus"  = Set default resource group
az config get defaults =  View default CLI settings
az show config =  Show full config details

 🗂️ Resource Group
az group create --name <name  --location <location  =  Create a resource group
az group list =  # List all resource groups
az group delete --name <name  =  Delete a specific resource group

 📦 Storage Account
az storage account list =  List all storage accounts
az storage account show --name <name  --resource-group <rg  =  Show details of a storage account

 🖥️ Virtual Machines
az vm list =  List all virtual machines
az vm list --query "[].name" --output tsv =  List only VM names
az vm list-skus --location <location  =  List VM sizes available in a region
az vm delete --name <vm  --resource-group <rg  =  Delete a VM

```

## POWERSHELL COMMANDS:
```

 🔐 Login and Subscription
Connect-AzAccount =  Sign in to Azure
Connect-AzAccount -UseDeviceAuthentication =  Device-based login method
Get-AzSubscription =  List all Azure subscriptions
Set-AzContext -Subscription <SUBSCRIPTION  =  Set active subscription
Get-AzAccount =  View signed-in account
Get-AzContext =  View current subscription and defaults

 🗂️ Resource Group
Get-AzResourceGroup =  List all resource groups
Get-AzResourceGroup -Location eastus2 =  Filter by location
Get-AzResourceGroup -Name parakram_rg_eastus =  Get details of a specific group
Remove-AzResourceGroup -Name <name  =  Delete a resource group

 📦 Storage Account
Get-AzStorageAccount =  List all storage accounts
Get-AzStorageAccount -Name <name  -ResourceGroupName <rg  =  Show storage account details

 🖥️ Virtual Machines
Get-AzVM =  List all virtual machines
Get-AzVM -Name <vm-name  =  Get details of a specific VM
Remove-AzVM -ResourceGroupName <rg  -Name <vm-name  =  Delete a VM
New-AzVM -Name <name  =  Create a new VM (with default config)
Set-AzVM -ResourceGroupName <rg  -Name <vm  =  Modify VM config
Set-AzVM -ResourceGroupName <rg  -Name <vm  -Generalized =  Mark VM as generalized

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
















