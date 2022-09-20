#!/bin/bash
#assign_policies_keyvault
keyVaultName=$1
objectId=$2
subscription=$3
rgName=$4
spCredPwd=$5
spCredUsr=$6
serverName=$7

if [ "$#" -ne 7 ]
then {
  echo "missing mandatory parameters"
  echo "Usage: ./assign_role_sqlcontributor.sh <keyVaultName> <objectId> <subscription_name> <rgName> <spcred> <spUsr> <servername>"
  echo "received parameters keyvaultName: $keyVaultName objectId: $objectId subscription name: $subscription rgName:$rgName pwd spusr:$spCredUsr servername:$serverName"
  exit 1
}
else {
  echo "received parameters keyvaultName: $keyVaultName objectId: $objectId subscription name: $subcription rgName:$rgName pwd spusr:$spCredUsr servername:$serverName"
}
fi

#add login sp
az login --service-principal -u "$spCredUsr" -p "$spCredPwd" --tenant "fed95e69-8d73-43fe-affb-a7d85ede36fb"
#az login --service-principal -u "https://nn-infra.visualstudio.com/AzureSubscription-frdap-dt" -p "$spCredPwd" --tenant "fed95e69-8d73-43fe-affb-a7d85ede36fb"

#set context
az account set --subscription $subscription
scope="/subscriptions/$subscription/resourceGroups/$rgName/providers/Microsoft.Storage/storageAccounts/$serverName"

role="Storage Blob Data Contributor"
echo "scope: $scope - role: $role"
az role assignment create --assignee-object-id "$objectId" --assignee-principal-type ServicePrincipal --role "$role" --scope "$scope"
