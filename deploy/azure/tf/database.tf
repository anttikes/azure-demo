resource "azurerm_mssql_server" "mssql_server" {
  name                = "sql-product-catalog-001"
  location            = azurerm_resource_group.rg_main.location
  resource_group_name = azurerm_resource_group.rg_main.name
  version             = "12.0"

  azuread_administrator {
    azuread_authentication_only = true
    login_username              = data.azuread_user.current_user.user_principal_name
    object_id                   = data.azuread_user.current_user.object_id
    tenant_id                   = data.azurerm_client_config.current.tenant_id
  }
}

resource "azurerm_mssql_virtual_network_rule" "example" {
  name      = "sql-vnet-rule"
  server_id = azurerm_mssql_server.mssql_server.id
  subnet_id = azurerm_subnet.snet_main.id
}

resource "azurerm_mssql_database" "mssql_database" {
  name                 = "db-product-catalog-001"
  server_id            = azurerm_mssql_server.mssql_server.id
  collation            = "SQL_Latin1_General_CP1_CI_AS"
  license_type         = "LicenseIncluded"
  sku_name             = "Basic"
  storage_account_type = "Local"
  max_size_gb          = 2
}
