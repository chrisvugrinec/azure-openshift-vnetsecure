az group deployment create -g vuggieopenshiftdemo --name vuggieopenshiftdemo \
      --template-uri https://raw.githubusercontent.com/Microsoft/openshift-origin/master/azuredeploy.json \
      --parameters @./openshift-origin-parameters.json
