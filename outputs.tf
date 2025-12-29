# ---------------------------------------------------------
# RESOURCE GROUP
# ---------------------------------------------------------
output "resource_group_name" {
  description = "The name of the resource group created"
  value       = module.resource_group.rg_name
}

# ---------------------------------------------------------
# CONTAINER REGISTRY (ACR)
# ---------------------------------------------------------
output "acr_login_server" {
  description = "The URL to login to docker (e.g. myacr.azurecr.io)"
  value       = module.acr.acr_login_server
}

output "acr_admin_username" {
  description = "Username for docker login"
  value       = module.acr.acr_admin_username
}

output "acr_admin_password" {
  description = "Password for docker login"
  value       = module.acr.acr_admin_password
  sensitive   = true # Hides it from the screen for security
}

# ---------------------------------------------------------
# VIRTUAL MACHINE (JUMPBOX)
# ---------------------------------------------------------
output "jumpbox_public_ip" {
  description = "Public IP of the Jumpbox VM"
  value       = module.vm.public_ip
}

output "jumpbox_ssh_command" {
  description = "Copy-paste this to SSH into the box"
  value       = module.vm.ssh_command
}

# ---------------------------------------------------------
# AKS CLUSTER
# ---------------------------------------------------------
# output "aks_cluster_name" {
#   description = "Name of the K8s Cluster"
#   value       = module.aks.aks_name
# }

# output "aks_get_credentials_command" {
#   description = "Command to configure kubectl on your local machine"
#   value       = "az aks get-credentials --resource-group ${module.resource_group.rg_name} --name ${module.aks.aks_name}"
# }