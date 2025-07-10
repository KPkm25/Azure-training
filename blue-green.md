## Blue green

```
export APP_NAME=kpkm-bg-app
export APP_ENVIRONMENT_NAME=dev-test
export RESOURCE_GROUP=parakram-19-06

# A commitId that is assumed to correspond to the app code currently in production
export BLUE_COMMIT_ID=fb699ef
# A commitId that is assumed to correspond to the new version of the code to be deployed
export GREEN_COMMIT_ID=c6f1515

# create an env
az containerapp env create \
  --name dev-test \
  --resource-group parakram-19-06 \
  --location centralindia


# create a new app with a new revision
az containerapp create --name $APP_NAME --environment $APP_ENVIRONMENT_NAME --resource-group $RESOURCE_GROUP --image mcr.microsoft.com/k8se/samples/test-app:$BLUE_COMMIT_ID --revision-suffix $BLUE_COMMIT_ID --env-vars REVISION_COMMIT_ID=$BLUE_COMMIT_ID --ingress external --target-port 80 --revisions-mode multiple

# Fix 100% of traffic to the revision
az containerapp ingress traffic set --name $APP_NAME --resource-group $RESOURCE_GROUP --revision-weight $APP_NAME--$BLUE_COMMIT_ID=100

# give that revision a label 'blue'
az containerapp revision label add --name $APP_NAME --resource-group $RESOURCE_GROUP --label blue --revision $APP_NAME--$BLUE_COMMIT_ID


#create a second revision for green commitId
az containerapp update --name $APP_NAME --resource-group $RESOURCE_GROUP --image mcr.microsoft.com/k8se/samples/test-app:$GREEN_COMMIT_ID --revision-suffix $GREEN_COMMIT_ID --set-env-vars REVISION_COMMIT_ID=$GREEN_COMMIT_ID

#give that revision a 'green' label
az containerapp revision label add --name $APP_NAME --resource-group $RESOURCE_GROUP --label green --revision $APP_NAME--$GREEN_COMMIT_ID

# The newly deployed revision can be tested by using the label-specific FQDN:

#get the containerapp environment default domain
export APP_DOMAIN=$(az containerapp env show -g $RESOURCE_GROUP -n $APP_ENVIRONMENT_NAME --query properties.defaultDomain -o tsv | tr -d '\r\n')

#Test the production FQDN
curl -s https://$APP_NAME.$APP_DOMAIN/api/env | jq | grep COMMIT

#Test the blue label FQDN
curl -s https://$APP_NAME---blue.$APP_DOMAIN/api/env | jq | grep COMMIT

#Test the green label FQDN
curl -s https://$APP_NAME---green.$APP_DOMAIN/api/env | jq | grep COMMIT

# set 100% of traffic to green revision
az containerapp ingress traffic set --name $APP_NAME --resource-group $RESOURCE_GROUP --label-weight blue=0 green=100

# set 100% of traffic to green revision
az containerapp ingress traffic set --name $APP_NAME --resource-group $RESOURCE_GROUP --label-weight blue=100 green=0


# Next deployment cycle

# set the new commitId
export BLUE_COMMIT_ID=ad1436b

# create a third revision for blue commitId
az containerapp update --name $APP_NAME --resource-group $RESOURCE_GROUP --image mcr.microsoft.com/k8se/samples/test-app:$BLUE_COMMIT_ID --revision-suffix $BLUE_COMMIT_ID --set-env-vars REVISION_COMMIT_ID=$BLUE_COMMIT_ID

# give that revision a 'blue' label
az containerapp revision label add --name $APP_NAME --resource-group $RESOURCE_GROUP --label blue --revision $APP_NAME--$BLUE_COMMIT_ID
```