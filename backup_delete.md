## 🗃️ Deleting a Recovery Services Vault in Azure: Step-by-Step Guide

### 🔧 Problem

Deleting a Recovery Services Vault after dealing with  backup items and soft-deleted resources still present in the vault.

---

### ✅ Final Goal

To **delete the Recovery Services Vault** and associated **resource group**.

---

### 🛠️ Steps Taken

#### IMP! Disable soft delete
```
https://learn.microsoft.com/en-us/azure/backup/backup-azure-security-feature-cloud?tabs=azure-portal#permanently-deleting-soft-deleted-backup-items
```

Always-on soft delete with extended retention
Soft delete is enabled on all newly created vaults by default. Always-on soft delete state is an opt-in feature. Once enabled, it can't be disabled (irreversible).

Additionally, you can extend the retention duration for deleted backup data, ranging from 14 to 180 days. By default, the retention duration is set to 14 days (as per basic soft delete) for the vault, and you can extend it as required. The soft delete doesn't cost you for first 14 days of retention; however, you're charged for the period beyond 14 days. Learn more about pricing.

Disable soft delete
You can disable the soft delete feature by using the following supported clients.

In the Azure portal, go to your vault, and then go to Settings > Properties.
In the Properties pane, select Security Settings Update.
In the Security and soft delete settings pane, clear the required checkboxes to disable soft delete.

#### 1. **Identified Blockers**

Azure CLI and Portal showed the error:

```
Vault cannot be deleted as there are backup items still present in soft delete state.
Resources: parakramstorage
```

#### 2. **Unregistered Backup Items**

You unregistered the containers from the vault:

* Opened the Recovery Services Vault in the Azure portal.
* Went to **Backup Items** > **Azure Storage**.
* Located the containers: `parakramstorage`.
* Stopped backup for each one and confirmed deletion of backup data.

#### 3. **Handled Soft Delete (Undelete First)**

Azure enables *soft delete* by default for backup items:

* You saw an **Un-delete** option instead of “Permanently delete.”
* Clicked **Un-delete** to restore the soft-deleted items.

#### 4. **Deleted Backup Items Permanently**

* After un-deleting, you **stopped backup again**, this time choosing **"Delete backup data"**.
* This allowed Azure to **permanently delete** the items.

#### 5. **Checked for Private Endpoints**

* Verified that no private endpoints were attached to the vault (a common blocker).

#### 6. **Retried Deletion**

* After all backups and containers were cleared, retried deletion of the Recovery Services Vault.

#### 7. ✅ **Successfully Deleted Vault**

---

### 📌 Final Note

You **must remove all backup items**, **stop protection**, and **explicitly delete backup data** (even from soft delete) before the vault can be removed.

Soft delete makes this process a bit tricky, as it prevents actual deletion for added safety and doesn't provide any force-delete option.

---
