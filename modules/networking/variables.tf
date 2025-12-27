variable "rg_name" { 
    type = string 
    }
variable "location" { 
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