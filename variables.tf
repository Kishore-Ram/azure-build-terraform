variable "location" { 
    default = "East US" 
}

variable "resource_group_name" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "vnet_cidr" {
  type = string
}

variable "subnet_aks_name" {
  type = string
}

variable "subnet_aks_cidr" {
  type = string
}

variable "subnet_bastion_name" {
  type = string
}

variable "subnet_bastion_cidr" {
  type = string
}

variable "tags" {
    type = map(string) 
}

variable "acr_name" {

}

variable "vm_admin_password" {
  type      = string
  sensitive = true
}