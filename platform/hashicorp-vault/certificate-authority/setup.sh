kubectl -n evelyn-platform port-forward vault-0 8200
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

# For Windows, import the root_ca and the intermediate_ca using MMC.

# Make your truststore
keytool -import -alias ca -file CA_cert.crt -storetype PKCS12 -keystore truststore.p12
keytool -import -alias ca-int -file intermediate.cert.pem -storetype PKCS12 -keystore truststore.p12
keytool -list -v -keystore truststore.p12
