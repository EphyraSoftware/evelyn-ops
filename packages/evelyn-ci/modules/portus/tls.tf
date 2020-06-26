resource "vault_pki_secret_backend_cert" "portus" {
  backend = "pki_intermediate"
  name = "evelyn-internal-role"

  auto_renew = true
  ttl = "720h"
  format = "pem"

  common_name = var.hostname
}

resource "kubernetes_secret" "portus-tls" {
  metadata {
    name = "portus-tls"
    namespace = var.namespace
  }

  data = {
    "tls.crt" = vault_pki_secret_backend_cert.portus.certificate
    "tls.key" = vault_pki_secret_backend_cert.portus.private_key
  }

  type = "kubernetes.io/tls"
}
