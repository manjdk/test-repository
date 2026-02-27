param location string = resourceGroup().location
param containerAppName string
param containerAppEnvName string
param acrName string
param imageName string
param imageTag string

// Reference existing ACR
resource acr 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' existing = {
  name: acrName
}

// Container Apps Environment
resource env 'Microsoft.App/managedEnvironments@2023-05-01' = {
  name: containerAppEnvName
  location: location
  properties: {}
}

// Container App with System Identity
resource app 'Microsoft.App/containerApps@2023-05-01' = {
  name: containerAppName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    managedEnvironmentId: env.id
    configuration: {
      ingress: {
        external: true
        targetPort: 80
      }
      registries: [
        {
          server: acr.properties.loginServer
          identity: 'system'
        }
      ]
    }
    template: {
      containers: [
        {
          name: containerAppName
          image: '${acr.properties.loginServer}/${imageName}:${imageTag}'
          resources: {
            cpu: 0.5
            memory: '1Gi'
          }
        }
      ]
    }
  }
}

// AcrPull Role Assignment
resource acrPull 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(app.id, acr.id, 'acrpull')
  scope: acr
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '7f951dda-4ed3-4680-a7ca-43fe172d538d' // AcrPull role ID
    )
    principalId: app.identity.principalId
    principalType: 'ServicePrincipal'
  }
}