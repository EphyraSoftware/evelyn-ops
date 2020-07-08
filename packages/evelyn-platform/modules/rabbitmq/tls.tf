resource "vault_pki_secret_backend_cert" "rabbitmq" {
  backend = "pki_intermediate"
  name = "evelyn-internal-role"

  auto_renew = true
  ttl = "720h"

  format = "pem"

  common_name = var.rabbitmq_hostname
}

resource "kubernetes_secret" "rabbitmq-tls" {
  metadata {
    name = "rabbitmq-tls"
    namespace = var.namespace
  }

  data = {
    "tls.crt" = vault_pki_secret_backend_cert.rabbitmq.certificate
    "tls.key" = vault_pki_secret_backend_cert.rabbitmq.private_key
  }
}
