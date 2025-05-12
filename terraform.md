## 📁 Main Terraform Files in Azure Projects

| File Name                  | Purpose                                                                                                       |
| -------------------------- | ------------------------------------------------------------------------------------------------------------- |
| `main.tf`                  | Core configuration file that defines Azure resources (e.g., virtual machines, storage accounts, networks).    |
| `providers.tf`             | Declares the Azure provider and required version. Optionally includes backend configuration for remote state. |
| `variables.tf`             | Declares input variables used in the configuration.                                                           |
| `terraform.tfvars`         | Provides actual values for the variables defined in `variables.tf`. Often excluded from version control.      |
| `outputs.tf`               | Defines output values (e.g., IP addresses, resource names) that are returned after deployment.                |                                                   |
| `.terraform.lock.hcl`      | Auto-generated lock file to ensure consistent provider versions.                                              |
| `terraform.tfstate`        | State file that tracks the current state of infrastructure (can be local or remote).                          |
| `terraform.tfstate.backup` | Backup of the previous state file.                                                                            |

## terraform init
Purpose: Initializes your Terraform project directory.

What it does:

-> Sets up the backend for state management (if configured).

-> Downloads the provider plugins (e.g., Azure Provider).

-> Prepares the working directory for other Terraform commands.

📌 Run this command first before using plan or apply.

## terraform plan
Purpose: Creates an execution plan and shows what Terraform will do.

What it does:

-> Compares your current configuration (.tf files) with the actual infrastructure (via the state file).

-> Displays a summary of actions it will take: Add, Change, or Destroy resources.

-> Helps you verify changes before applying them.

📌 It doesn't make any real changes—it's read-only and safe to run multiple times.

## terraform apply
Purpose: Applies the changes required to reach the desired state.

What it does:

-> Executes the actions proposed in terraform plan.

-> Provisions, updates, or deletes resources as defined in your .tf files.

-> Updates the terraform.tfstate file to reflect the current state of your infrastructure.

📌 By default, it asks for confirmation. You can auto-approve it with terraform apply -auto-approve