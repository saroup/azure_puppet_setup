# Query the region vnet
data "azurerm_virtual_network" "region_vnet" {
  name                = "${var.region_info.name}-vnet"
  resource_group_name = var.region_info.resource_group_name
}

# Query the default subnet on the core vnet
data "azurerm_subnet" "region_subnet" {
  name                 = "default"
  resource_group_name  = data.azurerm_virtual_network.region_vnet.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.region_vnet.name
}

# Query the pre-created Azure SSH key to use for SSH auth to Linux VMs
data "azurerm_ssh_public_key" "ssh_public_key" {
  name                = var.admin_auth.public_key_name
  resource_group_name = var.admin_auth.resource_group_name
}

# Define the script that will be executed on the vm as a template 
data "template_file" "linux_puppet_installation" {
    template = file("./scripts/linux/install_puppet_agent.tpl")
    vars = {
      server_ip = data.azurerm_network_interface.puppetsvr_nic.private_ip_address,
      certname  = var.certname
    }
}

data "azurerm_network_interface" "puppetsvr_nic" {
  name = "puppetsvr-nic"
  resource_group_name = var.region_info.resource_group_name
}
