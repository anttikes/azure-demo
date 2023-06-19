resource "azurerm_resource_group" "main" {
  name     = "rg-product-catalog"
  location = var.location
}

resource "azurerm_virtual_network" "main" {
  name                = "vnet-product-catalog"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/23"]
}

resource "azurerm_subnet" "main" {
  name                 = "snet-product-catalog"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.0.0/23"]

  service_endpoints = ["Microsoft.Sql"]
}
