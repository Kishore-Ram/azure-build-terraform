# ---------------------------------------------------------
# GLOBAL SETTINGS
# ---------------------------------------------------------
location = "eastus"

tags = {
  Environment = "POC"
  Project     = "AKS-FrontDoor-Build"
  CreatedBy   = "Terraform"
  Owner       = "Datta-Kishore"
}

# ---------------------------------------------------------
# RESOURCE GROUP
# ---------------------------------------------------------
resource_group_name = "rg-aks-secure-001"

# ---------------------------------------------------------
# NETWORKING
# ---------------------------------------------------------
vnet_name           = "vnet-aks-core"
vnet_cidr           = "10.0.0.0/16"

# Subnet 1: Future AKS Cluster (Large /24 or /22)
subnet_aks_name     = "snet-aks-nodes"
subnet_aks_cidr     = "10.0.1.0/24"

# Subnet 2: Jumpbox / Bastion (Small /24)
# Note: If you switch to PaaS Bastion later, name this "AzureBastionSubnet"
subnet_bastion_name = "snet-bastion-mgmt"
subnet_bastion_cidr = "10.0.2.0/24"

# ---------------------------------------------------------
# CONTAINER REGISTRY (ACR)
# ---------------------------------------------------------
# MUST be globally unique, lowercase, numbers/letters only.
# Example: "acr" + "yourname" + "date"
acr_name = "acrkishoredemo2024" 

# ---------------------------------------------------------
# VIRTUAL MACHINE (JUMPBOX)
# ---------------------------------------------------------
# Password Requirements: 12+ chars, 1 Uppercase, 1 Lowercase, 1 Number, 1 Special Char
vm_admin_password = "ChangeMe1234!$"