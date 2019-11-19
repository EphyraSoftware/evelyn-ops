# Log into Vault, then setup a policy for certificate administration

vault policy write -address=http://localhost:8200 ca-provisioner ca-provisioner.hcl

# Now switch to a user who has the ca-provisioner role.

vault secrets enable -address=http://localhost:8200 pki
vault secrets tune -address=http://localhost:8200 -max-lease-ttl=87600h pki
vault write -address=http://localhost:8200 -field=certificate pki/root/generate/internal common_name="evelyn.internal" ttl=87600h > CA_cert.crt
vault write -address=http://localhost:8200 pki/config/urls issuing_certificates="http://127.0.0.1:8200/v1/pki/ca" crl_distribution_points="http://127.0.0.1:8200/v1/pki/crl"

vault secrets enable -address=http://localhost:8200 -path=pki_int pki
vault secrets tune -address=http://localhost:8200 -max-lease-ttl=43800h pki_int
vault write -address=http://localhost:8200 -format=json pki_int/intermediate/generate/internal common_name="evelyn.internal Intermediate Authority" | jq -r '.data.csr' > pki_intermediate.csr
vault write -address=http://localhost:8200 -format=json pki/root/sign-intermediate csr=@pki_intermediate.csr format=pem_bundle ttl="43800h" | jq -r '.data.certificate' > intermediate.cert.pem
vault write -address=http://localhost:8200 pki_int/intermediate/set-signed certificate=@intermediate.cert.pem

vault write -address=http://localhost:8200 pki_int/roles/evelyn-internal allowed_domains="evelyn.internal" allow_subdomains=true max_ttl="720h"

vault write -address=http://localhost:8200 pki_int/issue/evelyn-internal common_name="nas.evelyn.internal" ttl="720h"

# For Windows, import the root_ca and the intermediate_ca using MMC.
