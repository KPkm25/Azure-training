## Basic Terraform code to create an AKS K8s cluster
```
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "aks_rg" {
  name     = "aks-resource-group"
  location = "East US"
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "my-aks-cluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "myaks"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
  }

  tags = {
    environment = "dev"
  }
}
```
## 1. What is a Node Pool?
A node pool in AKS represents a group of worker nodes with the same configuration (VM size, OS, scaling policy, etc.).

-> You can have multiple node pools, useful for running different workloads.

-> Each pool can have different VM types or Kubernetes versions.

| Node Pool Type       | Purpose                                                                         |
| -------------------- | ------------------------------------------------------------------------------- |
| **System Node Pool** | Hosts **critical system pods**: e.g., CoreDNS, kube-proxy, metrics server, etc. |
| **User Node Pool**   | Hosts **user workloads** like deployments, services, etc.                       |

Key differences:

AKS requires exactly one system node pool.

You can have multiple user node pools, and they can be tainted to isolate workloads.

## ✅ 2. Can I Run User Workloads in System Node Pools?
Technically, nothing stops you from scheduling pods in the system node pool.

It behaves like a regular node pool unless tainted.

Why you shouldn't:
-> System node pools host critical Kubernetes components (e.g., coredns, kube-proxy).

-> Running user workloads here may:

-> Cause resource contention

-> Risk system instability under load

## AKS Container Networking Interface (CNI)

Kubernetes uses Container Networking Interface (CNI) plugins to manage networking in Kubernetes clusters. CNIs are responsible for assigning IP addresses to pods, network routing between pods, Kubernetes Service routing, and more.

AKS provides multiple CNI plugins you can use in your clusters depending on your networking requirements.

AKS uses two main networking models: overlay network and flat network.


### Overlay networks
Overlay networking is the most common networking model used in Kubernetes. In overlay networks, pods are given an IP address from a private, logically separate CIDR from the Azure VNet subnet where AKS nodes are deployed. This allows for simpler and often better scalability than the flat network model.

In overlay networks, pods can communicate with each other directly. Traffic leaving the cluster is Source Network Address Translated (SNAT'd) to the node's IP address, and inbound Pod IP traffic is routed through some service, such as a load balancer. This means that the pod IP address is "hidden" behind the node's IP address. This approach reduces the number of VNet IP addresses required for your clusters.

-> Conserve VNet IP address space by using logically separate CIDR ranges for pods.

-> Maximum cluster scale support.

-> Simple IP address management.

-> Pod IPs aren’t reachable externally.

-> Slight overhead due to network encapsulation.

### Why SNAT in Kubernetes?
In AKS (and other K8s environments using overlay networks):

-> Pods have internal IPs (e.g., 10.x.x.x) that aren’t routable on the public internet.

-> When a pod sends traffic to an external service, SNAT replaces the pod’s IP with the node’s IP (which is routable).

-> The external service replies to the node, which then forwards the response back to the correct pod.

### Flat networks
Unlike an overlay network, a flat network model in AKS assigns IP addresses to pods from a subnet from the same Azure VNet as the AKS nodes. This means that traffic leaving your clusters is not SNAT'd, and the pod IP address is directly exposed to the destination. This can be useful for some scenarios, such as when you need to expose pod IP addresses to external services.

-> Pods get full VNet connectivity and can be directly reached via their private IP address from connected networks.

-> Require large, non-fragmented VNet IP address space.

-> Pod IPs are externally visible — helpful for diagnostics or integration with legacy systems.

-> More transparent routing without SNAT.

| CNI Plugin                    | Networking Model | Use Case Highlights                                                                                         |
|------------------------------|------------------|-------------------------------------------------------------------------------------------------------------|
| Azure CNI Overlay            | Overlay          | - Best for VNET IP conservation  <br> - Max node count supported by API Server + 250 pods per node <br> - Simpler configuration <br> - No direct external pod IP access |
| Azure CNI Pod Subnet         | Flat             | - Direct external pod access <br> - Modes for efficient VNet IP usage or large cluster scale support (Preview) |
| Kubenet (Legacy)             | Overlay          | - Prioritizes IP conservation <br> - Limited scale <br> - Manual route management                           |
| Azure CNI Node Subnet (Legacy) | Flat           | - Direct external pod access <br> - Simpler configuration <br> - Limited scale <br> - Inefficient use of VNet IPs |


