echo "resroucegroup name: "
read solname

az keyvault create -g $solname -n $solname-kv

# Adding private key to keyvault
az keyvault secret set --vault-name $solname-kv -n secretkey --file ~/.ssh/id_rsa

# Setting the policy for template-deployment
azure keyvault set-policy --vault-name $solname-kv --enabled-for-template-deployment true
