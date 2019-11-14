resource "tls_private_key" "keycloak_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource "tls_self_signed_cert" "keycloak_certificate" {
  key_algorithm   = tls_private_key.keycloak_key.algorithm
  private_key_pem = tls_private_key.keycloak_key.private_key_pem

  subject {
    common_name  = "keycloak.evelyn.internal"
    organization = "EphyraSoftware"
  }

  dns_names = ["keycloak.evelyn.internal"]

  validity_period_hours = 2190 // Three months

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "local_file" "key" {
  content     = tls_private_key.keycloak_key.private_key_pem
  filename = "${path.module}/tls.key"
}

resource "local_file" "certificate" {
  content     = tls_self_signed_cert.keycloak_certificate.cert_pem
  filename = "${path.module}/tls.crt"
}
