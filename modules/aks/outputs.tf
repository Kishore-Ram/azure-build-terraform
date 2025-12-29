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