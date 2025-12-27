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