resource "azurerm_mssql_server" "main" {
  name                = "sql-product-catalog"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  version             = "12.0"

  azuread_administrator {
    azuread_authentication_only = true
    login_username              = data.azuread_user.current_user.user_principal_name
    object_id                   = data.azuread_user.current_user.object_id
    tenant_id                   = data.azurerm_client_config.current.tenant_id
  }
}

resource "azurerm_mssql_database" "main" {
  name                 = "sqldb-product-catalog"
  server_id            = azurerm_mssql_server.main.id
  collation            = "SQL_Latin1_General_CP1_CI_AS"
  license_type         = "LicenseIncluded"
  sku_name             = "Basic"
  storage_account_type = "Local"
  max_size_gb          = 2
}
