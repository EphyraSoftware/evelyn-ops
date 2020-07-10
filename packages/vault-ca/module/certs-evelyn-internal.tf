resource "vault_pki_secret_backend_cert" "certs-nas" {
  depends_on = [vault_mount.intermediate-ca]

  backend = vault_mount.intermediate-ca.path
  name    = vault_pki_secret_backend_role.evelyn-internal-role.name

  auto_renew = true
  ttl        = "720h"
  format     = "pem"

  common_name = "nas.evelyn.internal"

  alt_names = ["nas.evelyn.internal"]
}

resource "vault_pki_secret_backend_cert" "certs-keycloak" {
  depends_on = [vault_mount.intermediate-ca]

  backend = vault_mount.intermediate-ca.path
  name    = vault_pki_secret_backend_role.evelyn-internal-role.name

  auto_renew = true
  ttl        = "720h"
  format     = "pem"

  common_name = "keycloak.evelyn.internal"

  alt_names = [
    "keycloak.evelyn.internal",
    "keycloak.evelyn-platform.svc.cluster.local"
  ]
}

resource "vault_pki_secret_backend_cert" "certs-service" {
  depends_on = [vault_mount.intermediate-ca]

  backend = vault_mount.intermediate-ca.path
  name    = vault_pki_secret_backend_role.evelyn-internal-role.name

  auto_renew = true
  ttl        = "720h"
  format     = "pem"

  common_name = "service.evelyn.internal"

  alt_names = [
    "service.evelyn.internal",
    "evelyn-web-entry-point.evelyn-services.svc.cluster.local"
  ]
}
