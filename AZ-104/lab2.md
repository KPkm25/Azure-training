## Built-in Role – Virtual Machine Contributor
### ✅ What does this role do?
The Virtual Machine Contributor role gives the user/group permission to:

-> Create, start, stop, restart, and delete VMs

-> Change VM configurations

But it does NOT allow:

-> Accessing the OS (e.g., RDP/SSH)

-> Managing network interfaces, IPs, or storage accounts the VM uses

This is useful for Help Desk staff: they can help troubleshoot or restart a VM but can’t break networking or access the system itself.

## Custom Role – Support Requests (with Restrictions)
### ✅ Why create a custom role?
Built-in roles like Support Request Contributor might include too many permissions, such as:

-> Creating support tickets ✅

-> Registering new resource providers ❌ (not needed and could pose a risk)

🔧 What you're doing:
-> Cloning the Support Request Contributor role

-> Excluding the permission: Microsoft.Support/register/action

This means: Users can create support tickets, but cannot register new services/providers, which is safer.

This is an example of least privilege: give only the exact permissions needed for the job.