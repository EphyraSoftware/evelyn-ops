output "root-ca" {
  value = vault_pki_secret_backend_root_cert.root-ca.certificate
}

output "ca" {
  value = vault_pki_secret_backend_intermediate_set_signed.intermediate-ca.certificate
}

output "keycloak-crt" {
  value = vault_pki_secret_backend_cert.certs-keycloak.certificate
}

output "keycloak-key" {
  value = vault_pki_secret_backend_cert.certs-keycloak.private_key
}
