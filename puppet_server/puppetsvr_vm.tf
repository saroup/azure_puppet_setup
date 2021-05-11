provider "azurerm" {
  features {}
}

resource "azurerm_linux_virtual_machine" "puppetserver" {
  name                = "puppetserver"
  resource_group_name = data.azurerm_virtual_network.region_vnet.resource_group_name
  location            = data.azurerm_virtual_network.region_vnet.location
  size                = "Standard_F2"
  admin_username      = var.admin_user
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.puppetsvr_nic.id,
  ]

  custom_data = base64encode(data.template_file.software_installation.rendered)

  admin_ssh_key {
    public_key = var.ssh_key
    username   = var.admin_user
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}