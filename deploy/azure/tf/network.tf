resource "azurerm_resource_group" "rg_main" {
  name     = "rg-product-catalog-001"
  location = var.location
}

resource "azurerm_virtual_network" "vnet_main" {
  name                = "vnet-product-catalog-001"
  location            = azurerm_resource_group.rg_main.location
  resource_group_name = azurerm_resource_group.rg_main.name
  address_space       = ["10.0.0.0/22"]
}

resource "azurerm_subnet" "snet_main" {
  name                 = "snet-product-catalog-001"
  resource_group_name  = azurerm_resource_group.rg_main.name
  virtual_network_name = azurerm_virtual_network.vnet_main.name
  address_prefixes     = ["10.0.0.0/23"]

  service_endpoints = ["Microsoft.Sql"]
}

resource "azurerm_subnet" "snet_container_apps" {
  name                 = "snet-integration-containerApps"
  resource_group_name  = azurerm_resource_group.rg_main.name
  virtual_network_name = azurerm_virtual_network.vnet_main.name
  address_prefixes     = ["10.0.2.0/23"]
}
