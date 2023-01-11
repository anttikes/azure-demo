@description('Specifies the name of the application; this value is embedded into the resource names')
param applicationName string = 'product-catalog'

@description('Specifies the Azure region where resources are deployed to')
param location string = 'westeurope'

targetScope = 'subscription'

resource rgMain 'Microsoft.Resources/resourceGroups@2022-09-01' = {
    name: 'rg-${applicationName}-001'
    location: location
  }

module vnetModule './network.bicep' = {
  name: 'virtualNetwork'
  scope: rgMain
  params: {
    applicationName: applicationName
    location: location
  }
}

module sqlServerModule './sqlServer.bicep' = {
  name: 'sqlServer'
  scope: rgMain
  params: {
    applicationName: applicationName
    location: location
    serviceEndpointSubnetId: vnetModule.outputs.containerAppSubnetId
  }
}

module containerAppsModule './containerApps.bicep' = {
  name: 'containerApps'
  scope: rgMain
  params: {
    applicationName: applicationName
    location: location
    serviceEndpointSubnetId: vnetModule.outputs.containerAppSubnetId
    sqlConnectionString: sqlServerModule.outputs.connectionString
  }
}

output containerAppFQDN string = containerAppsModule.outputs.containerAppFQDN
