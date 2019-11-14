terraform init
terraform apply -auto-approve

kubectl -n evelyn-platform create secret generic keycloak-tls --from-file=./tls.key --from-file=./tls.crt

kubectl apply --namespace evelyn-platform -f keycloak-postgres.yml

kubectl apply -n evelyn-platform -f keycloak.yml

# The following can be automated, and should be!
# Create a realm (look at the webapp) and a client
# Add the webapp URLs to the client config
# Add the Facebook identity provider and copy your app settings into the config.
# Ensure the app config on Facebook developer matches how the webapp is deployed.
