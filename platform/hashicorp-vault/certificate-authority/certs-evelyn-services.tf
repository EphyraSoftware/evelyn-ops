resource "vault_pki_secret_backend_cert" "certs-evelyn-web-entry-point" {
  depends_on = [ vault_mount.intermediate-ca ]

  backend = vault_mount.intermediate-ca.path
  name = vault_pki_secret_backend_role.evelyn-services-role.name

  common_name = "evelyn-web-entry-point.evelyn-services.svc.cluster.local"

  alt_names = [ "evelyn-web-entry-point.evelyn-services.svc.cluster.local" ]
}

resource "vault_pki_secret_backend_cert" "certs-evelyn-profile-service" {
  depends_on = [ vault_mount.intermediate-ca ]

  backend = vault_mount.intermediate-ca.path
  name = vault_pki_secret_backend_role.evelyn-services-role.name

  common_name = "evelyn-profile-service.evelyn-services.svc.cluster.local"

  alt_names = [ "evelyn-profile-service.evelyn-services.svc.cluster.local" ]
}
