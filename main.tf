module "resource_group" {
  source   = "./modules/resource_group"
  rg_name  = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "networking" {
  source              = "./modules/networking"
  rg_name             = module.resource_group.rg_name
  location            = module.resource_group.location
  vnet_name           = var.vnet_name
  vnet_cidr           = var.vnet_cidr
  subnet_aks_name     = var.subnet_aks_name
  subnet_aks_cidr     = var.subnet_aks_cidr
  subnet_bastion_name = var.subnet_bastion_name
  subnet_bastion_cidr = var.subnet_bastion_cidr
  tags                = var.tags
}


module "acr" {
  source   = "./modules/acr"
  acr_name = var.acr_name
  rg_name  = module.resource_group.rg_name
  location = module.resource_group.location
  sku      = "Standard"
  tags     = var.tags
}

module "vm" {
  source         = "./modules/virtual_machine"
  vm_name        = "vm-jumpbox-01"
  rg_name        = module.resource_group.rg_name
  location       = module.resource_group.location
  subnet_id      = module.networking.bastion_subnet_id
  tags           = var.tags
  
  # Auth details
  admin_username = "azureuser"
  admin_password = var.vm_admin_password
}

# ---------------------------------------------------------
# AKS CLUSTER (Private)
# ---------------------------------------------------------
module "aks" {
  source     = "./modules/aks"
  
  # Basic Settings
  aks_name   = "aks-demo-cluster-001"
  rg_name    = module.resource_group.rg_name
  location   = module.resource_group.location
  tags       = var.tags

  # Networking (Critical for Private Cluster)
  # We plug it into the AKS Subnet we created in the networking module
  subnet_id  = module.networking.aks_subnet_id

  # Optional Overrides (defaults are in modules/aks/variables.tf)
  vm_size    = "Standard_DC2as_v5"
  node_count = 1
}

# ---------------------------------------------------------
# PERMISSION: AKS -> ACR
# ---------------------------------------------------------
# This allows the AKS nodes to pull images from your Registry
resource "azurerm_role_assignment" "aks_to_acr" {
  scope                = module.acr.acr_id
  role_definition_name = "AcrPull"
  principal_id         = module.aks.kubelet_identity_object_id
}