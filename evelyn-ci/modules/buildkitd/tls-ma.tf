resource "vault_pki_secret_backend_role" "buildkitd-role" {
  backend = "pki_intermediate"
  name    = "buildkitd-role"

  max_ttl = "2592000"
  allow_subdomains = true
  basic_constraints_valid_for_non_ca = true
  allow_bare_domains = true
  allowed_domains = [ "evelyn-ci.svc", "evelyn-ci.svc.cluster.local", "edge.evelyn.internal", "client" ]

  key_usage = [
    "DigitalSignature",
    "KeyAgreement",
    "ServerAuth",
    "ClientAuth"
  ]
}

resource "vault_pki_secret_backend_cert" "buildkitd-server" {
  backend = "pki_intermediate"
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
  backend = "pki_intermediate"
  name = vault_pki_secret_backend_role.buildkitd-role.name

  auto_renew = true
  ttl = "720h"
  format = "pem"

  common_name = "client"
}
