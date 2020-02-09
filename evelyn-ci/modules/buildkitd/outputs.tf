output "ca-cert" {
  value = tls_self_signed_cert.ca-cert.cert_pem
}

output "client-cert-pem" {
  value = tls_locally_signed_cert.client.cert_pem
}

output "client-cert-key" {
  value = tls_private_key.client.private_key_pem
}
