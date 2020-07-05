resource "tls_private_key" "ca" {
  algorithm = "RSA"
  rsa_bits = 2048
}

resource "tls_self_signed_cert" "ca" {
  key_algorithm   = tls_private_key.ca.algorithm
  private_key_pem = tls_private_key.ca.private_key_pem

  subject {
    common_name  = "Vault server CA"
    organization = "Ephyra"
  }

  validity_period_hours = 720

  is_ca_certificate = true

  allowed_uses = [
    "cert_signing"
  ]
}

resource "tls_private_key" "vault" {
  algorithm = tls_self_signed_cert.ca.key_algorithm
  rsa_bits = 2048
}

resource "tls_cert_request" "vault" {
  key_algorithm   = tls_self_signed_cert.ca.key_algorithm
  private_key_pem = tls_private_key.vault.private_key_pem

  subject {
    common_name  = var.hostname
    organization = "Ephyra"
  }

  dns_names = [
    var.hostname
  ]
}

resource "tls_locally_signed_cert" "vault" {
  cert_request_pem   = tls_cert_request.vault.cert_request_pem
  ca_key_algorithm   = tls_self_signed_cert.ca.key_algorithm
  ca_private_key_pem = tls_private_key.ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem

  validity_period_hours = 720

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "kubernetes_secret" "vault-tls" {
  metadata {
    name = "vault-tls"
    namespace = kubernetes_namespace.vault.metadata.0.name
  }

  data = {
    "tls.crt" = tls_locally_signed_cert.vault.cert_pem
    "tls.key" = tls_private_key.vault.private_key_pem
  }

  type = "kubernetes.io/tls"
}
