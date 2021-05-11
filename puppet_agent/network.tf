# Allocating public IP addresses and opening ports is for development only 
# #TODO remove the public IP's and open ports once dev work is done. 
resource "azurerm_public_ip" "linux_vm_public_ip" {
  name                = "linux-public-ip"
  location            = data.azurerm_virtual_network.region_vnet.location
  resource_group_name = data.azurerm_virtual_network.region_vnet.resource_group_name
  allocation_method   = "Static"
}


resource "azurerm_network_security_group" "linux_vm_nsg" {
  name                = "linux-nsg"
  location            = data.azurerm_virtual_network.region_vnet.location
  resource_group_name = data.azurerm_virtual_network.region_vnet.resource_group_name

  security_rule {
    name                       = "ssh"
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

# Create the NIC for the linux VM 
resource "azurerm_network_interface" "linux_vm_nic" {
  name                = "linux-nic"
  location            = data.azurerm_virtual_network.region_vnet.location
  resource_group_name = data.azurerm_virtual_network.region_vnet.resource_group_name

  ip_configuration {
    name                          = "linux-internal-ip"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = data.azurerm_subnet.region_subnet.id
    public_ip_address_id          = azurerm_public_ip.linux_vm_public_ip.id
  }

}

resource "azurerm_network_interface_security_group_association" "linux_vm_nsg" {
  network_interface_id      = azurerm_network_interface.linux_vm_nic.id
  network_security_group_id = azurerm_network_security_group.linux_vm_nsg.id
}
