param applicationName string

@description('Resource identifier of the subnet for the service endpoint')
param serviceEndpointSubnetId string

param location string = resourceGroup().location

resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: 'sql-${applicationName}-001'
  location: location
  properties: {
    administratorLogin: 'superAdmin'
    administratorLoginPassword: 'v3ryd1ff1cUltP4$$w0rd=='
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

output adminConnectionString string = 'Server=tcp:${sqlServer.properties.fullyQualifiedDomainName},1433; Database=${sqlDB.name}; Authentication=Active Directory Integrated'
