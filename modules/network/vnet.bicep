@description('Creates a virtual network with specified subnets.')
param vnetName string

@description('The location where the virtual network will be created.')
param location string

@description('The address prefix for the virtual network.')
param vnetAddressPrefix array

@description('The subnets to be created within the virtual network.')
param subnets array

resource vnet 'Microsoft.Network/virtualNetworks@2025-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: vnetAddressPrefix
    }
    subnets: [
      for subnet in subnets: {
        name: subnet.name
        properties: {
          addressPrefix: subnet.addressPrefix
        }
      }
    ]
  }
}
