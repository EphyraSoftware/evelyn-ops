resource "vault_pki_secret_backend_cert" "certs-nas" {
  depends_on = [ vault_mount.intermediate-ca ]

  backend = vault_mount.intermediate-ca.path
  name = vault_pki_secret_backend_role.evelyn-internal-role.name

  common_name = "nas.evelyn.internal"

  alt_names = [ "nas.evelyn.internal" ]
}

resource "vault_pki_secret_backend_cert" "certs-service" {
  depends_on = [ vault_mount.intermediate-ca ]

  backend = vault_mount.intermediate-ca.path
  name = vault_pki_secret_backend_role.evelyn-internal-role.name

  common_name = "service.evelyn.internal"

  alt_names = [ "service.evelyn.internal" ]
}
