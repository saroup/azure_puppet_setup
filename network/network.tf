resource "azurerm_virtual_network" "region_vnet" {
  name                = "${var.region_info.name}-vnet"
  location            = azurerm_resource_group.region_rg.location
  resource_group_name = azurerm_resource_group.region_rg.name
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = "default"
    address_prefix = "10.0.1.0/24"
  }

  depends_on = [
    azurerm_resource_group.region_rg
  ]
}