#oc adm policy add-scc-to-group anyuid system:authenticated

oc new-app --docker-image=pengbai/docker-supermario:latest

