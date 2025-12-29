variable "aks_name" {
  description = "The name of the AKS Cluster"
  type        = string
}

variable "rg_name" {
  description = "Name of the Resource Group"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the Subnet where the AKS nodes will be placed"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

# Optional Variables with Defaults

variable "node_count" {
  description = "The initial number of nodes for the default node pool"
  type        = number
  default     = 1
}

variable "vm_size" {
  description = "The VM SKU for the AKS nodes"
  type        = string
  default     = "Standard_DS2_v2" # Reliable and cost-effective for dev
}