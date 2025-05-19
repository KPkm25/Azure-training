## Manage resources using ARM template

## Difference between Disks and Storage Accounts
| Feature | **Disk**                                          | **Storage Account**                                       |
| ------- | ------------------------------------------------- | --------------------------------------------------------- |
| Purpose | Used as virtual hard drives for VMs (OS or Data). | General-purpose storage for blobs, files, queues, tables. |
| Type    | Managed resource specific to VM.                  | Broad storage platform for apps, logs, files, etc.        |
| Scope   | Specific to virtual machines.                     | Used across services, including backup, analytics, etc.   |
| Example | OS Disk, Data Disk (Standard SSD, Premium SSD).   | Blob containers, file shares.                             |

### 🔹 Can we use a storage account to export a template?
-> No. Exporting a template is done via Azure Portal/CLI/PowerShell for a resource group or resource — not stored directly into a Storage Account unless you manually save it there afterward.

## 2. What is the difference between Template and Parameters JSON file?

| Feature     | **Template File (`template.json`)**                 | **Parameters File (`parameters.json`)**          |
| ----------- | --------------------------------------------------- | ------------------------------------------------ |
| Purpose     | Describes **what** resources to deploy and **how**. | Supplies **values** to customize the deployment. |
| Contents    | Resources, variables, outputs, parameters.          | Parameter names and user-provided values.        |
| Reusability | General-purpose, reusable for many deployments.     | Specific to environment (e.g., dev, prod).       |

**template.json**
```
{
  "parameters": {
    "vmName": {
      "type": "string"
    }
  },
  "resources": [
    {
      "type": "Microsoft.Compute/virtualMachines",
      "name": "[parameters('vmName')]",
      ...
    }
  ]
}
```
**parameters.json**
```
{
  "parameters": {
    "vmName": {
      "value": "MyVM-01"
    }
  }
}
```

##  3. What is the format of an ARM template file? Explain components with examples.
```
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {},
  "variables": {},
  "resources": [],
  "outputs": {}
}
```
```
 Components:
$schema: Defines the JSON schema used for validation.

contentVersion: Versioning for the template.

parameters: Inputs for customization.

variables: Reusable values within the template.

resources: Actual Azure resources to deploy.

outputs: Values returned after deployment (e.g., public IP).
```

##  4. How do I use an existing ARM template?

### Azure Portal:
-> Go to "Deploy a custom template".

-> Paste the template or upload it.

-> Provide parameter values and deploy.

### Azure CLI:
```
az deployment group create \
  --resource-group MyRG \
  --template-file template.json \
  --parameters parameters.json
```

### Powershell
```
New-AzResourceGroupDeployment `
  -ResourceGroupName "<resource-group-name>" `
  -TemplateFile "template.json" `
  -TemplateParameterFile "parameters.json"
```

##  5. Compare and contrast ARM Templates and Bicep
| Feature     | **ARM Template (JSON)**                  | **Bicep (DSL)**                                     |
| ----------- | ---------------------------------------- | --------------------------------------------------- |
| Format      | JSON                                     | Domain-specific language (.bicep)                   |
| Readability | Verbose, harder to maintain              | Clean, concise, readable                            |
| Tooling     | Built-in Azure support                   | Native support with Azure CLI & VS Code             |
| Reusability | Achievable but not intuitive             | Native modules, loops, conditions                   |
| Conversion  | Manual or with Azure Tools               | Can decompile from ARM template (`bicep decompile`) |
| Deployment  | Same engine (via Azure Resource Manager) | Same deployment backend                             |
