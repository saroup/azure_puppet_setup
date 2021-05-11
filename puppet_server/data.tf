data "azurerm_virtual_network" "region_vnet" {
  name                = "${var.region_info.name}-vnet"
  resource_group_name = var.region_info.resource_group_name
}

# Query the default subnet on the region vnet
data "azurerm_subnet" "region_subnet" {
  name                 = "default"
  resource_group_name  = data.azurerm_virtual_network.region_vnet.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.region_vnet.name
}

# Define the script that will be executed on the vm as a template 
data "template_file" "software_installation" {
    template = file("${path.module}/scripts/linux/install_puppet_server.tpl")
    vars = {
      certname =  var.certname
      gitlab_control_repo = var.gitlab_control_repo,
      registration_token = var.registration_token
      admin = var.admin_user
    }
}