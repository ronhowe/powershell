param appName string
param planName string
param configStoreName string
param location string
param skuName string = 'B2'
param skuCapacity int = 1

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: planName
  location: location
  sku: {
    name: skuName
    capacity: skuCapacity
  }
}

resource appService 'Microsoft.Web/sites@2022-09-01' = {
  name: appName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      alwaysOn: true
      metadata: [
        {
          name: 'CURRENT_STACK'
          value: 'dotnet'
        }
      ]
      netFrameworkVersion: 'v7.0'
      http20Enabled: true
      minTlsVersion: '1.2'
      use32BitWorkerProcess: false
    }
    httpsOnly: true
  }
  identity: {
    type: 'SystemAssigned'
  }
}

resource configStore 'Microsoft.AppConfiguration/configurationStores@2023-03-01' = {
  name: configStoreName
  location: location
  sku: {
    name: 'standard'
  }
  properties: {
    enablePurgeProtection: false
    softDeleteRetentionInDays: 0
  }
  identity: {
    type: 'SystemAssigned'
  }
}
