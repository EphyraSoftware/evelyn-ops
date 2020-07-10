resource "vault_pki_secret_backend_cert" "nexus" {
  backend = "pki_intermediate"
  name    = "evelyn-internal-role"

  auto_renew = true
  ttl        = "720h"

  format = "pem"

  common_name = "nexus.evelyn.internal"
}

resource "kubernetes_secret" "nexus-tls" {
  metadata {
    name      = "nexus-tls"
    namespace = var.namespace
  }

  data = {
    "tls.crt" = vault_pki_secret_backend_cert.nexus.certificate
    "tls.key" = vault_pki_secret_backend_cert.nexus.private_key
  }
}
