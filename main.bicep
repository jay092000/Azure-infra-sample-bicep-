param location string 
param vnet object
param storageAccountName string
param nsg object
param windowsVm object

param kvName string
param kvPasswordSecretName string

resource kv 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: kvName
}
module vnetDev 'modules/network/vnet.bicep' = {
  name: 'vnetDeployment'
  params: {
    vnetName: vnet.vnetName
    location: location
    vnetAddressPrefix: vnet.addressPrefix
    subnets: vnet.subnets
  }
}

module storage 'modules/storage/storage.bicep' = {
  name: 'storageDeployment'
  params: {
    storageAccountName: storageAccountName
    location: location
  }
}

module nsgDev 'modules/security/nsg.bicep' = {
  name: 'nsgDeployment'
  params: {
    nsgName: nsg.nsgName
    location: location
    securityRules: nsg.securityRules
    subnetArray: nsg.subnetstoAssociate
  }
}

module vmDev 'modules/vm/windowsVm.bicep' = {
  name: 'vmDeployment'
  params: {
    location: location
    baseName: windowsVm.baseVmName
    adminUserName: windowsVm.adminUsername
    vmSize: windowsVm.vmSize
      adminPassword: kv.getSecret(kvPasswordSecretName) 
    baseNicName: windowsVm.nicName
    virtualNetworkName: windowsVm.virtualNetworkName
    subnetName: windowsVm.subnetName
    count: windowsVm.vmCount
  }

  dependsOn:[
    nsgDev
  ]
}
