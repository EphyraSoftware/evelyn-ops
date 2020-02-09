locals {
  algorithm = "RSA"
}

resource "tls_private_key" "ca-key" {
  algorithm = local.algorithm
  rsa_bits = 4096
}

resource "tls_self_signed_cert" "ca-cert" {
  key_algorithm   = local.algorithm
  private_key_pem = tls_private_key.ca-key.private_key_pem

  subject {
    common_name  = "buildkitdca"
    organization = "Ephyra Software"
  }

  validity_period_hours = 720

  is_ca_certificate = true

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth",
  ]
}

resource "tls_private_key" "server" {
  algorithm = local.algorithm
  rsa_bits = 4096
}

resource "tls_cert_request" "server" {
  key_algorithm   = local.algorithm
  private_key_pem = tls_private_key.server.private_key_pem

  subject {
    common_name  = "${local.name}.${var.namespace}.svc"
    organization = "Ephyra Software"
  }

  dns_names = var.server_dns_names
}

resource "tls_locally_signed_cert" "server" {
  cert_request_pem   = tls_cert_request.server.cert_request_pem
  ca_key_algorithm   = local.algorithm
  ca_private_key_pem = tls_private_key.ca-key.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca-cert.cert_pem

  validity_period_hours = 720

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "tls_private_key" "client" {
  algorithm = local.algorithm
  rsa_bits = 4096
}

resource "tls_cert_request" "client" {
  key_algorithm   = local.algorithm
  private_key_pem = tls_private_key.client.private_key_pem

  subject {
    common_name  = "buildctl"
    organization = "Ephyra Software"
  }
}

resource "tls_locally_signed_cert" "client" {
  cert_request_pem   = tls_cert_request.client.cert_request_pem
  ca_key_algorithm   = local.algorithm
  ca_private_key_pem = tls_private_key.ca-key.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca-cert.cert_pem

  validity_period_hours = 720

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth",
  ]
}
