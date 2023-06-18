output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.rg_main.name
}

output "containerapps_environment_name" {
    description = "Name of the container apps environment"
    value       = azurerm_container_app_environment.ca_environment.name
}

output "containerapp_connection_string" {
    description = "Connection string for the container app"
    value       = "Server=tcp:${azurerm_mssql_server.mssql_server.fully_qualified_domain_name},1433; Initial Catalog=${azurerm_mssql_database.mssql_database.name}; Authentication=Active Directory Managed Identity; MultipleActiveResultSets=True; Encrypt=True; TrustServerCertificate=False;"
}
