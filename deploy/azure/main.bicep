targetScope = 'subscription'

@description('Specifies the name of the application; this value is embedded into the resource names')
param applicationName string = 'product-catalog-demo'

@description('Azure SQL administrator login')
param sqlAdministratorLogin string

@description('Azure SQL administrator password')
@secure()
param sqlAdministratorPassword string

@description('Specifies the Azure region where resources are deployed to')
param location string = 'westeurope'

resource rgMain 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'rg-${applicationName}-001'
  location: location
}

module vnet './network.bicep' = {
  name: 'virtualNetworkDeployment'
  scope: rgMain
  params: {
    applicationName: applicationName
    location: location
  }
}

module sqlServer './sqlServer.bicep' = {
  name: 'sqlServerDeployment'
  scope: rgMain
  params: {
    applicationName: applicationName
    location: location
    serviceEndpointSubnetId: vnet.outputs.containerAppSubnetId
  }
}

module containerApps './containerApps.bicep' = {
  name: 'containerAppsDeployment'
  scope: rgMain
  params: {
    applicationName: applicationName
    location: location
    serviceEndpointSubnetId: vnet.outputs.containerAppSubnetId
    sqlConnectionString: format(sqlServer.outputs.adminConnectionString, sqlAdministratorLogin, sqlAdministratorPassword)
  }
}
