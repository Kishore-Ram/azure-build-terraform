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

# Grant AKS permission to manage the Subnet
resource "azurerm_role_assignment" "aks_network_contributor" {
  scope                = module.networking.aks_subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = module.aks.aks_identity_object_id 
  # Note: You might need to add "output aks_identity_object_id" in your AKS module first
}

# 1. Find the Node Resource Group (Where the PLS actually lives)
#    Note: AKS creates a secondary RG named "MC_..."
data "azurerm_resource_group" "node_rg" {
  name = module.aks.node_resource_group
}

# 2. Look up the Private Link Service by its name "pls-aks-demo"
data "azurerm_private_link_service" "pls" {
  name                = "pls-aks-demo"
  resource_group_name = data.azurerm_resource_group.node_rg.name
}

# 3. Create Front Door and connect it
module "frontdoor" {
  source = "./modules/frontdoor"

  frontdoor_name = "fd-aks-demo-${random_id.rg_name.hex}" # Uses a random suffix
  rg_name        = module.resource_group.rg_name
  location       = module.resource_group.location
  
  # Pass the ID found by the data block above
  pls_id         = data.azurerm_private_link_service.pls.id
}

# 4. Output the URL
output "frontdoor_endpoint_url" {
  value = module.frontdoor.frontdoor_url
}