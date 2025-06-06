param storageAccountName string = 'myStorageAccount'
param location string = resourceGroup().location

var uniqueStorageName = '${storageAccountName}${uniqueString(resourceGroup().id)}'
var tags = {
  Environment: 'Development'
  Project: 'BicepExample'
}

type StorageAccountConfig = {
  name: string
  location: string
  sku: string
}

func generateStorageName(prefix string, suffix string) string => '${prefix}-${suffix}'

metadata description = 'This template creates a storage account with blob container'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: uniqueStorageName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  tags: tags
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2021-02-01' = {
  parent: storageAccount
  name: 'default'
}

module networkModule './network.bicep' = {
  name: 'networkDeployment'
  params: {
    location: location
  }
}

output storageAccountId string = storageAccount.id
output storageAccountName string = storageAccount.name
output blobEndpoint string = storageAccount.properties.primaryEndpoints.blob

test testStorageAccount './tests/storage.test.bicep' = {
  params: {
    storageAccountName: 'teststorage'
    location: 'eastus'
  }
}

assert storageNameValid = length(storageAccount.name) <= 24