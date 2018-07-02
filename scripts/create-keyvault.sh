az keyvault create -g vuggie-openshift1 -n vuggie-openshift1

# Adding private key to keyvault
azure keyvault secret set -u vuggie-openshift1 -s vuggie-openshift1-key1 --file ~/.ssh/id_rsa

# Setting the policy for template-deployment
azure keyvault set-policy -u vuggie-openshift1 --enabled-for-template-deployment true
