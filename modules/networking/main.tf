resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.rg_name
  address_space       = [var.vnet_cidr]
  tags                = var.tags
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = var.subnet_aks_name
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_aks_cidr]
}

resource "azurerm_subnet" "bastion_subnet" {
  name                 = var.subnet_bastion_name
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_bastion_cidr]
}

resource "azurerm_network_security_group" "nsg_bastion" {
  name                = "nsg-bastion-allow-ssh"
  location            = var.location
  resource_group_name = var.rg_name

  # Rule: Allow SSH (Port 22) from ANYWHERE
  # Security Note: In production, change "*" to your specific laptop IP (e.g., "123.45.67.89/32")
  security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*" 
    destination_address_prefix = "*"
  }
}

# 2. Link the NSG to the Bastion Subnet
resource "azurerm_subnet_network_security_group_association" "bastion_assoc" {
  subnet_id                 = azurerm_subnet.bastion_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg_bastion.id
}