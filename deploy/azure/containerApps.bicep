param applicationName string

@description('Resource identifier of the subnet for the service endpoint')
param serviceEndpointSubnetId string

@description('Connection string for the SQL server; should use managed identity')
param sqlConnectionString string

param location string = resourceGroup().location

resource logWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: 'law-${applicationName}-001'
  location: location
  properties: {
    retentionInDays: 30
    sku: {
      name: 'PerGB2018'
    }
    workspaceCapping: {
      dailyQuotaGb: 1
    }
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

resource caApp 'Microsoft.App/containerApps@2022-03-01' = {
  name: 'ca-${applicationName}-001'
  location: location
  properties: {
    managedEnvironmentId: caEnvironment.id
    configuration: {
      activeRevisionsMode: 'Single'
      ingress: {
        allowInsecure: false
        external: true
        targetPort: 80
      }
    }
    template: {
      containers: [
        {
          image: 'ghcr.io/anttikes/product-catalog.api:latest'
          name: 'ca-${applicationName}-001'
          resources: {
            cpu: json('0.5')
            memory: '1.0Gi'
          }
          env: [
            {
              name: 'FUNCTIONS_WORKER_RUNTIME'
              value: 'dotnet-isolated'
            }
            {
              name: 'SQL_CONNECTION_STRING'
              value: sqlConnectionString
            }
            {
                name: 'AzureWebJobsSecretStorageType'
                value: 'files'
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

output containerAppFQDN string = caApp.properties.configuration.ingress.fqdn
