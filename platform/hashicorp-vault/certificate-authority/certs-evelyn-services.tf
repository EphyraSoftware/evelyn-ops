resource "vault_pki_secret_backend_cert" "certs-evelyn-profile-service" {
  depends_on = [ vault_mount.intermediate-ca ]

  backend = vault_mount.intermediate-ca.path
  name = vault_pki_secret_backend_role.evelyn-services-role.name

  auto_renew = true
  ttl = "720h"
  format = "pem"

  common_name = "evelyn-profile-service.evelyn-services.svc.cluster.local"

  alt_names = [ "evelyn-profile-service.evelyn-services.svc.cluster.local" ]
}

resource "vault_pki_secret_backend_cert" "certs-evelyn-group-service" {
  depends_on = [ vault_mount.intermediate-ca ]

  backend = vault_mount.intermediate-ca.path
  name = vault_pki_secret_backend_role.evelyn-services-role.name

  auto_renew = true
  ttl = "720h"
  format = "pem"

  common_name = "evelyn-group-service.evelyn-services.svc.cluster.local"

  alt_names = [ "evelyn-group-service.evelyn-services.svc.cluster.local" ]
}

