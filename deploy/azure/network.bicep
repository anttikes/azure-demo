param applicationName string

param location string = resourceGroup().location

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-05-01' = {
  name: 'vnet-${applicationName}-001'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/21'
      ]
    }
  }
}

// The subnet CIDR requirement for Container Apps is unfortunately large; hopefully Microsoft fixes it at some point
resource subnetContainerApps 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  name: 'snet-integration-containerapps'
  parent: virtualNetwork
  properties: {
    addressPrefix: '10.0.0.0/21'
    serviceEndpoints: [
      { service: 'Microsoft.Sql' }
    ]
  }
}

output containerAppSubnetId string = subnetContainerApps.id
