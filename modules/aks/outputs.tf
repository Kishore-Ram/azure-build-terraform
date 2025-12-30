output "aks_id" {
  value = azurerm_kubernetes_cluster.aks.id
}

output "aks_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

# This is critical for ACR Pull
output "kubelet_identity_object_id" {
  value = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}


output "aks_identity_object_id" {
  # This grabs the "System Assigned Identity" of the cluster
  value = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}

# Ensure you also have this (needed for the PLS data block later):
output "node_resource_group" {
  value = azurerm_kubernetes_cluster.aks.node_resource_group
}