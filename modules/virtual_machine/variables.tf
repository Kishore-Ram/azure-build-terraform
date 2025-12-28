variable "vm_name" { type = string }
variable "rg_name" { type = string }
variable "location" { type = string }
variable "subnet_id" { type = string }
variable "tags" { type = map(string) }

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "admin_password" {
  type      = string
  sensitive = true # Hides output in CLI
}