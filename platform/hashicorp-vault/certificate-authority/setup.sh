kubectl -n evelyn-platform port-forward vault-0 8200
# kubectl exec -it vault-0 -n evelyn-platform sh
# set VAULT_ADDR=http://localhost:8200
vault login -address=http://localhost:8200 # root user

pushd bootstrap
terraform init
terraform plan
terraform apply
popd

vault login -method github -address=http://localhost:8200

pushd certificate-authority
terraform init
terraform plan
terraform apply
popd

# Run the truststore.cmd script to do the last little bit that terraform can't yet!

# For Windows, import the root_ca and the intermediate_ca using MMC.
