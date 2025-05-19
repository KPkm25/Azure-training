## Implement virtual networking
** Do again **

-> What is the difference between ASG and NSG, how are the 2 connected?
-> Public and private DNS zones along with DNS management and record set
---

## ASG vs NSG
| Feature                 | **NSG (Network Security Group)**                            | **ASG (Application Security Group)**                                 |
| ----------------------- | ----------------------------------------------------------- | -------------------------------------------------------------------- |
| **Purpose**             | Control **inbound/outbound traffic** at subnet or NIC level | Group VMs **logically** for applying NSG rules based on workload     |
| **Scope**               | Applied to **subnets or network interfaces (NICs)**         | Applied to **VM NICs only**                                          |
| **Rules**               | Uses IP addresses, port ranges, protocols                   | Can reference **ASG** instead of IPs in NSG rules                    |
| **Dynamic IP Handling** | Static IP-based — hard to maintain at scale                 | Dynamic — VMs added to ASG automatically follow rules                |
| **Use Case**            | Apply general traffic control rules (e.g., block port 3389) | Apply role/workload-based rules (e.g., only web servers talk to DBs) |

## Public vs Private DNS
| Feature           | **Public DNS Zone**                          | **Private DNS Zone**                                     |
| ----------------- | -------------------------------------------- | -------------------------------------------------------- |
| **Accessibility** | Globally resolvable over the internet        | Only resolvable inside your **Azure virtual network(s)** |
| **Use Case**      | Hosting websites, APIs, services on internet | Internal service discovery (e.g., `db.internal.contoso`) |
| **Examples**      | `myapp.com`, `api.company.com`               | `myapp.local`, `internal.contoso.com`                    |
