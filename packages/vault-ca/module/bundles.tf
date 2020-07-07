provider "keystore" {
  path = "\\\\nas.evelyn.internal\\terraform\\.files\\bundles"
}

resource "keystore_pkcs12_bundle" "calendar-service" {
  name = "calendar-service-keystore"
  cert_pem = vault_pki_secret_backend_cert.certs-evelyn-calendar-service.certificate
  key_pem = vault_pki_secret_backend_cert.certs-evelyn-calendar-service.private_key
  ca_certs = [
    vault_pki_secret_backend_root_cert.root-ca.certificate,
    vault_pki_secret_backend_root_sign_intermediate.intermediate-ca.certificate
  ]
}

resource "keystore_pkcs12_bundle" "group-service" {
  name = "group-service-keystore"
  cert_pem = vault_pki_secret_backend_cert.certs-evelyn-group-service.certificate
  key_pem = vault_pki_secret_backend_cert.certs-evelyn-group-service.private_key
  ca_certs = [
    vault_pki_secret_backend_root_cert.root-ca.certificate,
    vault_pki_secret_backend_root_sign_intermediate.intermediate-ca.certificate
  ]
}

resource "keystore_pkcs12_bundle" "profile-service" {
  name = "profile-service-keystore"
  cert_pem = vault_pki_secret_backend_cert.certs-evelyn-profile-service.certificate
  key_pem = vault_pki_secret_backend_cert.certs-evelyn-profile-service.private_key
  ca_certs = [
    vault_pki_secret_backend_root_cert.root-ca.certificate,
    vault_pki_secret_backend_root_sign_intermediate.intermediate-ca.certificate
  ]
}

resource "keystore_pkcs12_bundle" "task-service" {
  name = "task-service-keystore"
  cert_pem = vault_pki_secret_backend_cert.certs-evelyn-task-service.certificate
  key_pem = vault_pki_secret_backend_cert.certs-evelyn-task-service.private_key
  ca_certs = [
    vault_pki_secret_backend_root_cert.root-ca.certificate,
    vault_pki_secret_backend_root_sign_intermediate.intermediate-ca.certificate
  ]
}

resource "keystore_pkcs12_bundle" "todo-service" {
  name = "todo-service-keystore"
  cert_pem = vault_pki_secret_backend_cert.certs-evelyn-todo-service.certificate
  key_pem = vault_pki_secret_backend_cert.certs-evelyn-todo-service.private_key
  ca_certs = [
    vault_pki_secret_backend_root_cert.root-ca.certificate,
    vault_pki_secret_backend_root_sign_intermediate.intermediate-ca.certificate
  ]
}

resource "keystore_pkcs12_bundle" "web-entry-point" {
  name = "web-entry-point-keystore"
  cert_pem = vault_pki_secret_backend_cert.certs-service.certificate
  key_pem = vault_pki_secret_backend_cert.certs-service.private_key
  ca_certs = [
    vault_pki_secret_backend_root_cert.root-ca.certificate,
    vault_pki_secret_backend_root_sign_intermediate.intermediate-ca.certificate
  ]
}
