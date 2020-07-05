resource "vault_pki_secret_backend_cert" "keycloak" {
  backend = "pki_intermediate"
  name = "evelyn-internal-role"

  auto_renew = true
  ttl = "720h"

  format = "pem"

  common_name = var.keycloak_hostname
}

resource "kubernetes_secret" "keycloak-tls" {
  metadata {
    name = "keycloak-tls"
    namespace = var.namespace
  }

  data = {
    "tls.crt" = vault_pki_secret_backend_cert.keycloak.certificate
    "tls.key" = vault_pki_secret_backend_cert.keycloak.private_key
  }
}
