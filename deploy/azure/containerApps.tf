resource "azurerm_log_analytics_workspace" "main" {
  name                = "law-product-catalog-001"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "main" {
  name                       = "cae-product-catalog"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  infrastructure_subnet_id   = azurerm_subnet.main.id
}

resource "azurerm_container_app" "main" {
  name                         = "product-catalog-backend"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
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
    min_replicas = 0
    max_replicas = 5
    revision_suffix = "primary"

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
        value = "Server=tcp:${azurerm_mssql_server.main.fully_qualified_domain_name},1433; Database=${azurerm_mssql_database.main.name}; Authentication=Active Directory Managed Identity; Encrypt=True; TrustServerCertificate=False; MultipleActiveResultSets=True;"
      }
    }
  }
}
