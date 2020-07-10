resource "vault_pki_secret_backend_cert" "grafana" {
  backend = "pki_intermediate"
  name    = "evelyn-internal-role"

  auto_renew = true
  ttl        = "720h"

  format = "pem"

  common_name = var.grafana_hostname
}

resource "kubernetes_secret" "grafana-tls" {
  metadata {
    name      = "grafana-tls"
    namespace = var.namespace
  }

  data = {
    "tls.crt" = vault_pki_secret_backend_cert.grafana.certificate
    "tls.key" = vault_pki_secret_backend_cert.grafana.private_key
  }
}
