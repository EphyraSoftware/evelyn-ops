# Install Helm verion 3+

git clone https://github.com/hashicorp/vault-helm.git
cd vault-helm || exit

git checkout v0.2.1

# Set storageClass to be rook-ceph-block
# Set ui.enabled to be true, this is a security issue but I'm working on a private network.

helm install vault . --namespace evelyn-platform

# Wait for the vault container to be in the running state.

kubectl -n evelyn-platform exec -it vault-0 sh

# On first run
# $ vault operator init

# After a restart, and on first run
# $ vault operator unseal

# On first run
# $ vault login <root token>
# $ vault auth enable github
# $ vault write auth/github/config organization=EphyraSoftware
# $ vault write auth/github/map/teams/ephyra-dev value=default,ca-provisioner

# To access the vault
# kubectl -n evelyn-platform port-forward vault-0 8200
# vault login -method=github -address=http://localhost:8200 token=<person_access_token>
