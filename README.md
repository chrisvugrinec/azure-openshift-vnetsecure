# azure-openshift-vnetsecure

After a vanila Openshift installation on Azure you will have a container orchestrator which can be used directly with out of the box loads of dev/ops features. 

However most enterprise customers like to use Openshift within the confinements of the enterprise (cloud) network. Usually they would have an on premise network that is linked to an Azure vnet via an Express route/ VPN or a combination of both. The Azure vnet would be peered or routed to a vnet that contains the OpenShift installation.

This demo shows the basic security steps you can take after an Openshift installation on Azure, making sure that NO services can be publically exposed to the Internet and that Basic Authentication and Authorization is configured for a group of developers.

- Remove public LoadBalancers used by default installation, Create internal loadbalancer For the Master and for the worker nodes Ingress later on
- Create a custom role that has the appropriate rights for the resourcegroup, but al least remove the possibility to create a public ip address
- Remove the role of the Service Prinicpal that was used for the openshift installation and apply the custom role to this service prinicipal
- Create new User with default Authentication ; Add User to openshift group and assign policy to group on a project/namespace basis


# Installation, openshift origin

Installation is based on the instructions from: https://docs.microsoft.com/en-us/azure/virtual-machines/linux/openshift-origin
Before following the instructions, do this 1st:
- create SP and give the proper rights
  - az ad sp create-for-rbac -n [ NAME OF SP ] --password [ SP PASSWORD ] --role contributor --scopes /subscriptions/[ YOUR SUBSCRIPTION ID ] (do a "az account show" for this info)
- create resourcegroups for openshift and keyvault
  - az group create -n [ NAME OF RG FOR OSO ] -l [ REGION ]
  - az group create -n [ NAME OF RG FOR KV ] -l [ REGION ]
- create keyvault
  - az keyvault create -n [ NAME OF KEYVAULT ] -g [ NAME OF RG FOR KV ] -l [ REGION ] --enabled-for-template-deployment true
- set private ssh key in keyvault you just created
  - az keyvault secret set --vault-name [ KEYVAULT NAME ] -n keysecret --file ~/.ssh/id_rsa



# Create user and put in developer group

- To be done by CLUSTERADMIN: oc adm policy add-role-to-user admin system:serviceaccount:testproject:tiller

- oc create user chris --full-name="Chris Vugrinec"a
- ssh on each masternode and add user chris to htpasswd
- for eg, if you have 3 masters
- ssh clusteradmin@masterdns75l3yb5ke.westeurope.cloudapp.azure.com -p 2200
- ssh clusteradmin@masterdns75l3yb5ke.westeurope.cloudapp.azure.com -p 2201
- ssh clusteradmin@masterdns75l3yb5ke.westeurope.cloudapp.azure.com -p 2202
- sudo htpasswd /etc/origin/master/htpasswd chris
- Make sure users cannot create new projects/ namespaces anymore
  - oc adm policy remove-cluster-role-from-group self-provisioner system:authenticated system:authenticated:oauth
- Make sure that user chris can only access testproject as developer
  - oc adm groups new developers
  - oc adm groups add-users developers chris
  - oc adm policy add-role-to-group admin developer -n testproject
  - oc adm policy add-role-to-user admin chris -n testproject

# Another ISSUE

You cannot run images from dockerhub that run as root...on openshift...
in order to enable this:
oc adm policy add-scc-to-group anyuid system:authenticated


