output "vnet_id" { 
    value = azurerm_virtual_network.vnet.id 
    }

output "aks_subnet_id" { 
    value = azurerm_subnet.aks_subnet.id 
    }

output "bastion_subnet_id" { 
    value = azurerm_subnet.bastion_subnet.id 
    }