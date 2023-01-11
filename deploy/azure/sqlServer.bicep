param applicationName string

@description('Resource identifier of the subnet for the service endpoint')
param serviceEndpointSubnetId string

param location string = resourceGroup().location

var administratorLoginPassword = 'v3ryd1ff1cUltP4$$w0rd=='

resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: 'sql-${applicationName}-001'
  location: location
  properties: {
    administratorLogin: 'superAdmin'
    administratorLoginPassword: administratorLoginPassword
  }
}

resource virtualNetworkRule 'Microsoft.Sql/servers/virtualNetworkRules@2022-05-01-preview' = {
  name: 'vnetRule'
  parent: sqlServer
  properties: {
    virtualNetworkSubnetId: serviceEndpointSubnetId
  }
}

resource sqlDB 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  parent: sqlServer
  name: 'sqldb-${applicationName}-001'
  location: location
  sku: {
    name: 'Basic'
  }
}

output connectionString string = 'Server=tcp:${sqlServer.properties.fullyQualifiedDomainName},1433; Initial Catalog=${sqlDB.name}; User Id=${sqlServer.properties.administratorLogin}; Password=${administratorLoginPassword}; MultipleActiveResultSets=True; Encrypt=True; TrustServerCertificate=True;'
