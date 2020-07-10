resource "vault_pki_secret_backend_role" "evelyn-internal-role" {
  depends_on = [vault_pki_secret_backend_intermediate_set_signed.intermediate-ca]

  backend = vault_mount.intermediate-ca.path
  name    = "evelyn-internal-role"

  max_ttl                            = "2592000"
  key_bits                           = 4096
  allow_subdomains                   = true
  basic_constraints_valid_for_non_ca = true
  allowed_domains = [
    "evelyn.internal",
    "evelyn-services.svc.cluster.local",
    "evelyn-platform.svc.cluster.local"
  ]

  key_usage = [
    "DigitalSignature",
    "KeyAgreement",
    "ServerAuth"
  ]
}

resource "vault_pki_secret_backend_role" "evelyn-services-role" {
  depends_on = [vault_pki_secret_backend_intermediate_set_signed.intermediate-ca]

  backend = vault_mount.intermediate-ca.path
  name    = "evelyn-services-role"

  max_ttl                            = "2592000"
  allow_subdomains                   = true
  basic_constraints_valid_for_non_ca = true
  allowed_domains                    = ["evelyn-services.svc.cluster.local"]

  key_usage = [
    "DigitalSignature",
    "KeyAgreement",
    "ServerAuth"
  ]
}
