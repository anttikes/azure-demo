resource "azurerm_log_analytics_workspace" "law_containerapps" {
  name                = "law-product-catalog-001"
  location            = azurerm_resource_group.rg_main.location
  resource_group_name = azurerm_resource_group.rg_main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "ca_environment" {
  name                       = "cae-product-catalog-001"
  location                   = azurerm_resource_group.rg_main.location
  resource_group_name        = azurerm_resource_group.rg_main.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law_containerapps.id
  infrastructure_subnet_id   = azurerm_subnet.snet_container_apps.id
}

resource "azurerm_container_app" "ca_product_catalog" {
  name                         = "ca-product-catalog-001"
  container_app_environment_id = azurerm_container_app_environment.ca_environment.id
  resource_group_name          = azurerm_resource_group.rg_main.name
  revision_mode                = "Single"

  identity {
    type = "SystemAssigned"
  }

  ingress {
    allow_insecure_connections = false
    external_enabled = true
    target_port = 80
    traffic_weight {
      percentage = 100
      latest_revision = true
    }
  }

  template {
    container {
      name   = "product-catalog"
      image  = "ghcr.io/anttikes/product-catalog.api:latest"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name = "AzureWebJobsSecretStorageType"
        value = "files"
      }

      env {
        name = "FUNCTIONS_WORKER_RUNTIME"
        value = "dotnet-isolated"
      }

      env {
        name = "SQL_CONNECTION_STRING"
        value = "Server=tcp:${azurerm_mssql_server.mssql_server.fully_qualified_domain_name},1433; Database=${azurerm_mssql_database.mssql_database.name}; Authentication=Active Directory Managed Identity; Encrypt=True; TrustServerCertificate=False; MultipleActiveResultSets=True;"
      }
    }
  }
}

resource "null_resource" "create-sql-user" {
  provisioner "local-exec" {
    command = <<EOT
      Install-Module -Name SqlServer -Force
      Invoke-Sqlcmd -Query "CREATE USER [${azurerm_container_app.ca_product_catalog.name}] FROM EXTERNAL PROVIDER" -ConnectionString "Server=tcp:${azurerm_mssql_server.mssql_server.fully_qualified_domain_name},1433; Database=${azurerm_mssql_database.mssql_database.name}; Authentication=Active Directory Default; Encrypt=True; TrustServerCertificate=False;"
      Invoke-Sqlcmd -Query "ALTER ROLE [db_owner] ADD MEMBER [${azurerm_container_app.ca_product_catalog.name}]" -ConnectionString "Server=tcp:${azurerm_mssql_server.mssql_server.fully_qualified_domain_name},1433; Database=${azurerm_mssql_database.mssql_database.name}; Authentication=Active Directory Default; Encrypt=True; TrustServerCertificate=False;"
    EOT

    interpreter = ["pwsh", "-Command"]
  }

  depends_on = [azurerm_mssql_database.mssql_database, azurerm_container_app.ca_product_catalog]
}
