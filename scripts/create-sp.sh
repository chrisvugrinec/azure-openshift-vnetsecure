#!/bin/bash

if [[ $1 == "--login" ]]
then
   az login
fi

az account list -o table
echo "please select subscription: "
read sub
az account set --subscription $sub

echo "resroucegroup name: "
read solname
echo "location: "
read location
echo "password for user: http://$solname"
read password

# create resourcegroup
az group create -n $solname -l $location

az ad sp create-for-rbac -n $solname --role="Contributor" --scopes=/subscriptions/$sub/resourceGroups/$solname --password=$password
az role assignment create --scope /subscriptions/$sub/resourceGroups/$solname --role Contributor --assignee http://$solname

# list role
az role assignment list --assignee 8c571dbc-5e47-4ed5-a017-2de1b9764c2f

# test service principal
 az login --service-principal --username http://vuggie-openshift1 --password XXXYOURPWD! --tenant 72f988bf-86f1-41af-91ab-2d7cd01XXXX
