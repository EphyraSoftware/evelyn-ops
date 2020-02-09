resource "vault_pki_secret_backend_cert" "buildkitd-server" {
  depends_on = [ vault_mount.intermediate-ca ]

  backend = vault_mount.intermediate-ca.path
  name = vault_pki_secret_backend_role.buildkitd-role.name

  auto_renew = true
  ttl = "720h"
  format = "pem"

  common_name = "buildkitd.evelyn-ci.svc"

  alt_names = [
    "edge.evelyn.internal",
    "buildkitd.evelyn-ci.svc.cluster.local"
  ]
}

resource "vault_pki_secret_backend_cert" "buildkitd-client" {
  depends_on = [ vault_mount.intermediate-ca ]

  backend = vault_mount.intermediate-ca.path
  name = vault_pki_secret_backend_role.buildkitd-role.name

  auto_renew = true
  ttl = "720h"
  format = "pem"

  common_name = "client"
}
