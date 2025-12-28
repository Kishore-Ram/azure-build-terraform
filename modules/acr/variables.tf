variable "acr_name" 
{ 
    type = string 
}

variable "rg_name" 
{ 
    type = string 
}

variable "location" 
{ 
    type = string 
}

variable "sku" 
{ 
  type    = string
  default = "Standard" # Options: Basic, Standard, Premium
}

variable "admin_enabled" 
{
  type    = bool
  default = true # Useful for easy login testing, usually false in strict Prod
}

variable "tags" 
{ 
    type = map(string) 
}