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

output "buildkitd-server-crt" {
  value = vault_pki_secret_backend_cert.buildkitd-server.certificate
}

output "buildkitd-server-key" {
  value = vault_pki_secret_backend_cert.buildkitd-server.private_key
}

output "buildkitd-client-crt" {
  value = vault_pki_secret_backend_cert.buildkitd-client.certificate
}

output "buildkitd-client-key" {
  value = vault_pki_secret_backend_cert.buildkitd-client.private_key
}

resource "local_file" "ca-out" {
  filename = "ca.crt"
  content = vault_pki_secret_backend_root_cert.root-ca.certificate
}

resource "local_file" "ca-int-out" {
  filename = "ca-int.crt"
  content = vault_pki_secret_backend_intermediate_set_signed.intermediate-ca.certificate
}
