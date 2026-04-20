@description('Azure region')
param location string

@description('VM size, e.g. Standard_D2s_v3')
param vmSize string

@description('Admin username')
param adminUserName string = 'azureadmin'

@secure() 
@description('Admin password (or use Key Vault reference in the parameter file)')
param adminPassword string

@description('Base name for VM and NIC resources')
param baseName string

@description('Target virtual network name')
param virtualNetworkName string

@description('Target subnet name')
param subnetName string

@description('Base name for NIC resources')
param baseNicName string


@description('How many VMs to create')
param count int = 1



resource nics 'Microsoft.Network/networkInterfaces@2024-07-01' = [for c in range(0, count):{ 
  name: '${baseNicName}-${c}'
  location:location
  properties: { 
    ipConfigurations: [ {
      name: 'ipconfig-01'
      properties: { 
        privateIPAllocationMethod:'Dynamic'
        subnet: {id:resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, subnetName) }
      }
    }]
  }
}]

resource vms 'Microsoft.Compute/virtualMachines@2024-07-01' = [for c in range(0, count):{ 
   name: '${baseName}-${c}'
   location:location
   properties: { 
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: '${baseName}-${c}'
      adminUsername: adminUserName
      adminPassword: adminPassword
      
    }

     storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer:     'WindowsServer'
        sku:       '2025-datacenter'
        version:   'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
    }

    networkProfile: {
      networkInterfaces:[ {
        id:nics[c].id
        properties: { primary: true }
      }]
    }
   }
}]
