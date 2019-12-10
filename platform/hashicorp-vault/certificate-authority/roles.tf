resource "vault_pki_secret_backend_role" "evelyn-internal-role" {
  backend = vault_mount.intermediate-ca.path
  name    = "evelyn-internal-role"

  max_ttl = 720
  allow_subdomains = true
  basic_constraints_valid_for_non_ca = true
  allowed_domains = [ "evelyn.internal" ]

  key_usage = [
    "DigitalSignature",
    "KeyAgreement",
    "KeyEncipherment",
    "ServerAuth"
  ]
}

resource "vault_pki_secret_backend_role" "evelyn-services-role" {
  backend = vault_mount.intermediate-ca.path
  name    = "evelyn-services-role"

  max_ttl = 720
  allow_subdomains = true
  basic_constraints_valid_for_non_ca = true
  allowed_domains = [ "evelyn-services.svc.cluster.local" ]

  key_usage = [
    "DigitalSignature",
    "KeyAgreement",
    "KeyEncipherment",
    "ServerAuth"
  ]
}
