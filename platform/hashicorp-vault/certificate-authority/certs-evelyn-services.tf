resource "vault_pki_secret_backend_cert" "certs-evelyn-calendar-service" {
  depends_on = [ vault_mount.intermediate-ca ]

  backend = vault_mount.intermediate-ca.path
  name = vault_pki_secret_backend_role.evelyn-services-role.name

  auto_renew = true
  ttl = "720h"
  format = "pem"

  common_name = "evelyn-calendar-service.${var.services_namespace}.svc.cluster.local"

  alt_names = [ "evelyn-calendar-service.${var.services_namespace}.svc.cluster.local" ]
}

resource "vault_pki_secret_backend_cert" "certs-evelyn-group-service" {
  depends_on = [ vault_mount.intermediate-ca ]

  backend = vault_mount.intermediate-ca.path
  name = vault_pki_secret_backend_role.evelyn-services-role.name

  auto_renew = true
  ttl = "720h"
  format = "pem"

  common_name = "evelyn-group-service.${var.services_namespace}.svc.cluster.local"

  alt_names = [ "evelyn-group-service.${var.services_namespace}.svc.cluster.local" ]
}

resource "vault_pki_secret_backend_cert" "certs-evelyn-profile-service" {
  depends_on = [ vault_mount.intermediate-ca ]

  backend = vault_mount.intermediate-ca.path
  name = vault_pki_secret_backend_role.evelyn-services-role.name

  auto_renew = true
  ttl = "720h"
  format = "pem"

  common_name = "evelyn-profile-service.${var.services_namespace}.svc.cluster.local"

  alt_names = [ "evelyn-profile-service.${var.services_namespace}.svc.cluster.local" ]
}

resource "vault_pki_secret_backend_cert" "certs-evelyn-task-service" {
  depends_on = [ vault_mount.intermediate-ca ]

  backend = vault_mount.intermediate-ca.path
  name = vault_pki_secret_backend_role.evelyn-services-role.name

  auto_renew = true
  ttl = "720h"
  format = "pem"

  common_name = "evelyn-task-service.${var.services_namespace}.svc.cluster.local"

  alt_names = [ "evelyn-profile-service.${var.services_namespace}.svc.cluster.local" ]
}
