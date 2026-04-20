@description('Name of the storage account')
param storageAccountName string

@description('The location where the storage account will be created.')
param location string

resource sa 'Microsoft.Storage/storageAccounts@2025-08-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}
