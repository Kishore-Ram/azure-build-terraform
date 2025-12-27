variable "location" { default = "East US" }
variable "resource_group_name" {}
variable "vnet_name" {}
variable "vnet_cidr" {}
variable "subnet_aks_name" {}
variable "subnet_aks_cidr" {}
variable "subnet_bastion_name" {}
variable "subnet_bastion_cidr" {}
variable "tags" { type = map(string) }