output "ca" {
  value = tls_self_signed_cert.ca.cert_pem
}

output "vault-cert" {
  value = tls_locally_signed_cert.vault.cert_pem
}
