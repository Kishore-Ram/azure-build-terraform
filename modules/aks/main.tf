resource "azurerm_kubernetes_cluster" "aks" {
  name                    = var.aks_name
  location                = var.location
  resource_group_name     = var.rg_name
  dns_prefix              = "${var.aks_name}-dns"
  
  # 1. MAKE IT PRIVATE
  # This removes the Public IP from the API Server.
  # You can only run kubectl from the Jumpbox/VNet.
  private_cluster_enabled = true
  
  # 2. DNS ZONE (System Managed)
  # Azure creates a Private DNS Zone for us automatically.
  private_dns_zone_id     = "System"

  sku_tier                = "Free" 

  default_node_pool {
    name           = "agentpool"
    node_count     = var.node_count
    vm_size        = var.vm_size
    vnet_subnet_id = var.subnet_id 
    
    enable_auto_scaling = false
    min_count           = null
    max_count           = null
  }

  identity {
    type = "SystemAssigned"
  }

network_profile {
    network_plugin    = "azure" 
    load_balancer_sku = "standard"
    network_policy    = "azure"
    
    # 1. The Virtual IP range for Kubernetes Services (Must NOT be in your VNet)
    service_cidr      = "172.16.0.0/16"
    
    # 2. The IP of the internal DNS (Must be inside the service_cidr)
    dns_service_ip    = "172.16.0.10"
    
    # 3. Docker Bridge (Just needs to be unique)
    docker_bridge_cidr = "172.17.0.1/16"
  }

  # 3. Grant ACR Pull Access (Using kubelet identity)
  # We do this linkage in the Root main.tf, but the cluster
  # needs to exist first.
  
  tags = var.tags
}