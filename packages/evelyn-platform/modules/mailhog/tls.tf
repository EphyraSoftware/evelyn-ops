resource "vault_pki_secret_backend_cert" "mailhog" {
  backend = "pki_intermediate"
  name = "evelyn-internal-role"

  auto_renew = true
  ttl = "720h"

  format = "pem"

  common_name = var.hostname
}

resource "kubernetes_secret" "mailhog-tls" {
  metadata {
    name = "mailhog-tls"
    namespace = var.namespace
  }

  data = {
    "tls.crt" = vault_pki_secret_backend_cert.mailhog.certificate
    "tls.key" = vault_pki_secret_backend_cert.mailhog.private_key
  }
}
