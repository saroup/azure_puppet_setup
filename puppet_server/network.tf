
# Allocating public IP addresses and opening ports is for development only  
# remove the public IP and ssh ports once your dev work is done
resource "azurerm_public_ip" "puppetsvr_public_ip" {
  name                         = "puppetsvr-public-ip"
  location                     = data.azurerm_virtual_network.region_vnet.location
  resource_group_name          = data.azurerm_virtual_network.region_vnet.resource_group_name
  allocation_method            = "Static"
  idle_timeout_in_minutes      = 30
}


resource "azurerm_network_interface" "puppetsvr_nic" {
  name                = "puppetsvr-nic"
  location            = data.azurerm_virtual_network.region_vnet.location
  resource_group_name = data.azurerm_virtual_network.region_vnet.resource_group_name

  ip_configuration {
    name                          = "puppetsvr-internal-ip"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = data.azurerm_subnet.region_subnet.id
    public_ip_address_id          = azurerm_public_ip.puppetsvr_public_ip.id
  }
}

resource "azurerm_network_security_group" "puppetsvr_nsg" {
  name                = "puppetsvr-nsg"
  location            = data.azurerm_virtual_network.region_vnet.location
  resource_group_name = data.azurerm_virtual_network.region_vnet.resource_group_name

  # #TODO remove when dev work is done
  security_rule {
    name                       = "ssh"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
    security_rule {
    name                       = "puppet"
    priority                   = 320
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8140"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
    security_rule {
    name                       = "puppetdb"
    priority                   = 340
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8081"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_interface_security_group_association" "nic_association_sg" {
  network_interface_id      = azurerm_network_interface.puppetsvr_nic.id
  network_security_group_id = azurerm_network_security_group.puppetsvr_nsg.id
}