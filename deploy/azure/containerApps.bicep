param applicationName string

@description('Resource identifier of the subnet for the service endpoint')
param serviceEndpointSubnetId string

@description('Connection string for the SQL server; should use managed identity')
param sqlConnectionString string

param location string = resourceGroup().location

var acrPullRole = resourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')

resource logWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: 'law-${applicationName}-001'
  location: location
  properties: {
    retentionInDays: 5
    sku: {
      name: 'PerGB2018'
    }
    workspaceCapping: {
      dailyQuotaGb: 1
    }
  }
}

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' = {
  name: 'acr-${applicationName}-001'
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {    
    adminUserEnabled: true 
  }
}

resource caEnvironment 'Microsoft.App/managedEnvironments@2022-06-01-preview' = {
  name: 'cae-${applicationName}-001'
  location: location
  sku: {
    name: 'Consumption'
  }
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logWorkspace.properties.customerId
        sharedKey: logWorkspace.listKeys().primarySharedKey
      }
    }
    vnetConfiguration: {
      infrastructureSubnetId: serviceEndpointSubnetId
      internal: false
    }
  }
}

resource functionApp 'Microsoft.App/containerApps@2022-03-01' = {
  name: 'ca-${applicationName}-001'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    managedEnvironmentId: caEnvironment.id
    configuration: {
      activeRevisionsMode: 'Single'      
      ingress: {
        allowInsecure: false
        external: true
        targetPort: 80
        traffic: [
          {
            latestRevision: true
            weight: 100
          }
        ]
      }
      registries: [
        {
          identity: 'system'
          server: containerRegistry.properties.loginServer
        }
      ]      
    }    
    template: {
      revisionSuffix: 'firstVersion'
      containers: [
        {
          image: 'nginx'
          name: 'ca-${applicationName}-001'
          resources: {
            cpu: json('0.5')
            memory: '1.0Gi'
          } 
          env: [
            {
              name: 'SQL_CONNECTION_STRING'
              value: sqlConnectionString
            }
          ]         
        }
      ]      
      scale: {
        minReplicas: 0
        maxReplicas: 1
      }
    }
  }
}

resource containerAppPullRBAC 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: 'rbac-${functionApp.name}'
  scope: containerRegistry
  properties: {    
    roleDefinitionId: acrPullRole
    principalId: functionApp.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

output containerAppFQDN string = functionApp.properties.configuration.ingress.fqdn
