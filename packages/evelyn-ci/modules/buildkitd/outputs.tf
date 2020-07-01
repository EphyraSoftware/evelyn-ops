output "client-cert-pem" {
  value = vault_pki_secret_backend_cert.buildkitd-client.certificate
}

output "client-cert-key" {
  value = vault_pki_secret_backend_cert.buildkitd-client.private_key
}

output "ca-bundle" {
  value = vault_pki_secret_backend_cert.buildkitd-server.ca_chain
}
