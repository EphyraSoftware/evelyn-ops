resource "vault_pki_secret_backend_role" "traefik" {
  backend = "pki_intermediate"
  name    = "traefik-role"

  max_ttl = "2592000"
  allow_subdomains = true
  basic_constraints_valid_for_non_ca = true
  allow_bare_domains = true
  allowed_domains = [ "evelyn.internal" ]

  key_usage = [
    "DigitalSignature",
    "KeyAgreement",
    "ServerAuth",
    "ClientAuth"
  ]
}

resource "vault_pki_secret_backend_cert" "traefik" {
  backend = "pki_intermediate"
  name = vault_pki_secret_backend_role.traefik.name

  auto_renew = true
  ttl = "720h"

  format = "pem"

  common_name = "traefik.evelyn.internal"
}

resource "kubernetes_secret" "traefik-tls" {
  metadata {
    name = "traefik-tls"
    namespace = var.namespace
  }

  data = {
    "tls.crt" = vault_pki_secret_backend_cert.traefik.certificate
    "tls.key" = vault_pki_secret_backend_cert.traefik.private_key
  }
}
