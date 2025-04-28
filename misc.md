**Router**: Forwards traffic between different networks.

**Gateway**: Entry/exit point of a network (think of it as a router + firewall).

**Bridge**: Connects two network segments and makes them act as one.

**PaaS** - Any service that can be customizable for the user

**HCL** -  Hashicorp Configuration Language

**Subnetting (Subnet and VNET):** Dividing a network (VNET) into smaller networks (subnets) for better organization, security, and routing.

**ARP:** Address Resolution Protocol that maps IP addresses to physical MAC addresses on a local network.

**IP:** Internet Protocol, the unique identifier assigned to each device on a network for communication.

**Routers, Gateways, Bridges:** Routers connect different networks, gateways act as access points between networks, and bridges connect devices within the same network.

**Bastion Host:** A secure server that provides safe remote access (SSH/RDP) to virtual machines without exposing them to the public internet.

**Region, Zone, Geographical Areas, Availability Zones:** Physical data center locations (regions) divided into isolated areas (availability zones) to ensure redundancy and high availability.

**Can create subnets in VNET/VPC:** Yes, subnets are segments created inside a VNET (Azure) or VPC (AWS) to organize resources and manage traffic better.

**VPC/VNET Peering (advantage and uses):** Directly connects two VPCs/VNETs allowing secure, low-latency communication without using public internet, reducing costs and improving security.

**Public/Private Subnets → VNET → Availability Zones → Subnets:**

**Public subnet:** Accessible from the internet.

**Private subnet:** No direct internet access.

**VNET:** A virtual private network in Azure.

**Availability Zones:** Physically separate data center locations within a region.

**Subnets:** Logical divisions inside a VNET.

**Virtual Machine Scale Set + Load Balancer:** A group of identical, auto-scaling VMs distributed by a load balancer to ensure high availability and performance.

**Fault Domain:** A logical grouping of hardware to prevent simultaneous failure due to hardware issues (e.g., server racks).

**Availability Sets:** Groups of VMs distributed across multiple fault and update domains to ensure high availability during planned/unplanned outages.

**A VM has to come from a subnet/VNET/availability zone:** Yes, a VM must be deployed inside a subnet (inside a VNET) and can optionally be placed in a specific availability zone.

**Resource Group in Azure:** A container that holds related Azure resources for easier management and billing.

**NAT Gateway:** A service that provides outbound internet access for resources in a private subnet while keeping them secure.

**Network Security Group (NSG):** A firewall rule set that controls inbound and outbound traffic to Azure resources at the subnet or NIC level.

**Route Table:** A set of rules (routes) used to determine where network traffic is directed.

**BGP Community String:** A tag used in Border Gateway Protocol (BGP) to group prefixes and control routing decisions.

**ICMP Port:** ICMP (Internet Control Message Protocol) doesn't use ports; it's used for sending error messages and operational information (e.g., ping).

**Relational DBs vs NoSQL:** Relational databases prioritize strong consistency and structured schemas, while NoSQL databases often trade strict consistency for scalability and flexibility.

**Azure Functions:** Serverless compute service that lets you run event-driven code without managing servers.

**ArgoCD:** A declarative, GitOps-based continuous delivery tool for Kubernetes that syncs your applications with Git repositories.

**FluxCD:** Another GitOps operator for Kubernetes that automates deployment by reconciling the cluster state from Git.