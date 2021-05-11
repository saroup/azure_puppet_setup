# resource group that will contain the virtual wan 
# and the virtual hubs
resource "azurerm_resource_group" "region_rg" {
  name     = var.region_info.resource_group_name
  location = var.region_info.location
}

