provider "azurerm" {
  features {}
}

# Create the Linux VM
resource "azurerm_linux_virtual_machine" "linux_vm" {
  count = var.linux_vm_info.vm_count

  name                       = "linuxvm"
  resource_group_name        = data.azurerm_virtual_network.region_vnet.resource_group_name
  location                   = data.azurerm_virtual_network.region_vnet.location
  size                       = var.linux_vm_info.size
  admin_username             = var.admin_auth.user_name
  admin_password             = var.admin_auth.admin_password
  network_interface_ids      = [azurerm_network_interface.linux_vm_nic.id]
  allow_extension_operations = true

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    name                 = "linux_vm-osdsk"
  }

  custom_data = base64encode(data.template_file.linux_puppet_installation.rendered)

  admin_ssh_key {
    # replace carriage return and new line from the SSH key before setting
    public_key = replace(data.azurerm_ssh_public_key.ssh_public_key.public_key, "\r\n", "")
    username   = var.admin_auth.user_name
  }

  source_image_reference {
    publisher = var.linux_vm_info.os_publisher
    offer     = var.linux_vm_info.os_offer
    sku       = var.linux_vm_info.os_sku
    version   = var.linux_vm_info.os_version
  }
}
