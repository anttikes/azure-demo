// Represents a data block to get the public IP of the computer running this script
data "http" "mypublicip" {
  url = "http://ipv4.icanhazip.com"
}

// Add a firewall rule to allow traffic from this address; this is required in order to execute the Invoke-SqlCmd statements in the "containerApps.tf" file
resource "azurerm_mssql_firewall_rule" "firewallRule1" {
    name = "allow-inbound-from-client"
    server_id = azurerm_mssql_server.main.id
    start_ip_address = "${chomp(data.http.mypublicip.response_body)}"
    end_ip_address = "${chomp(data.http.mypublicip.response_body)}"
}

// Add a virtual network rule to allow traffic from the infrastructure subnet
resource "azurerm_mssql_virtual_network_rule" "vnetRule1" {
  name      = "allow-inbound-from-vnet-main-subnet-main"
  server_id = azurerm_mssql_server.main.id
  subnet_id = azurerm_subnet.main.id
}

resource "null_resource" "create-sql-user" {
  provisioner "local-exec" {
    command = <<EOT
      Install-Module -Name SqlServer -Force
      Invoke-Sqlcmd -Query "CREATE USER [${azurerm_container_app.main.name}] FROM EXTERNAL PROVIDER" -ConnectionString "Server=tcp:${azurerm_mssql_server.main.fully_qualified_domain_name},1433; Database=${azurerm_mssql_database.main.name}; Authentication=Active Directory Default; Encrypt=True; TrustServerCertificate=False;"
      Invoke-Sqlcmd -Query "ALTER ROLE [db_owner] ADD MEMBER [${azurerm_container_app.main.name}]" -ConnectionString "Server=tcp:${azurerm_mssql_server.main.fully_qualified_domain_name},1433; Database=${azurerm_mssql_database.main.name}; Authentication=Active Directory Default; Encrypt=True; TrustServerCertificate=False;"
    EOT

    interpreter = ["pwsh", "-Command"]
  }

  depends_on = [azurerm_mssql_database.main, azurerm_container_app.main]
}
