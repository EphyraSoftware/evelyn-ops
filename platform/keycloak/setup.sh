terraform init
terraform apply -auto-approve

kubectl -n evelyn-platform create secret generic keycloak-tls --from-file=./tls.key --from-file=./tls.crt

kubectl apply --namespace evelyn-platform -f keycloak-postgres.yml

kubectl apply -n evelyn-platform -f keycloak.yml
