@description('Name of the Network Security Group')
param nsgName string

@description('The location where the Network Security Group will be created.')
param location string 

@description('Array of security rules to be applied to the Network Security Group')
param securityRules array

@description('Array of subnets to associate with the Network Security Group')
param subnetArray array

resource nsg 'Microsoft.Network/networkSecurityGroups@2025-05-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      for rule in securityRules: {
        name: rule.name
        properties: {
          protocol: rule.properties.protocol
          sourcePortRange: rule.properties.sourcePortRange
          destinationPortRange: rule.properties.destinationPortRange
          sourceAddressPrefix: rule.properties.sourceAddressPrefix
          destinationAddressPrefix: rule.properties.destinationAddressPrefix
          access: rule.properties.access
          priority: rule.properties.priority
          direction: rule.properties.direction
        }
      }
    ]
  }
}


resource subnetAssc 'Microsoft.Network/virtualNetworks/subnets@2025-05-01' = [for subnet in  subnetArray: {
  name:  '${subnet.virtualNetworkName}/${subnet.subnetName}'
  properties: {
    addressPrefix: subnet.addressPrefix
    networkSecurityGroup: {
      id: nsg.id
    }
  }
}]
