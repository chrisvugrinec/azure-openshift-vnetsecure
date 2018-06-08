# azure-openshift-vnetsecure

After a vanila Openshift installation on Azure you will have a container orchestrator which can be used directly with out of the box loads of dev/ops features. 

However most enterprise customers like to use Openshift within the confinements of the enterprise (cloud) network. Usually they would have an on premise network that is linked to an Azure vnet via an Express route/ VPN or a combination of both. The Azure vnet would be peered or routed to a vnet that contains the OpenShift installation.

This demo shows the basic security steps you can take after an Openshift installation on Azure, making sure that NO services can be publically exposed to the Internet and that Basic Authentication and Authorization is configured for a group of developers.

- Remove public LoadBalancers used by default installation, Create internal loadbalancer For the Master and for the worker nodes Ingress later on
- Create a custom role that has the appropriate rights for the resourcegroup, but al least remove the possibility to create a public ip address
- Remove the role of the Service Prinicpal that was used for the openshift installation and apply the custom role to this service prinicipal
- Create new User with default Authentication ; Add User to openshift group and assign policy to group on a project/namespace basis
