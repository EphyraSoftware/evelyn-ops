resource "vault_mount" "intermediate-ca" {
  path        = "pki_intermediate"
  type        = "pki"
  description = "Container for the intermediate CA"

  default_lease_ttl_seconds = 2592000   # 30 days
  max_lease_ttl_seconds     = 157680000 # 5 years
}

resource "vault_pki_secret_backend_intermediate_cert_request" "intermediate-ca" {
  depends_on = [vault_mount.intermediate-ca, vault_pki_secret_backend_root_cert.root-ca]

  backend = vault_mount.intermediate-ca.path

  type = "exported"

  common_name = "evelyn.internal Intermediate CA"
}

resource "vault_pki_secret_backend_root_sign_intermediate" "intermediate-ca" {
  depends_on = [vault_pki_secret_backend_intermediate_cert_request.intermediate-ca]

  backend = vault_mount.root-ca.path

  csr = vault_pki_secret_backend_intermediate_cert_request.intermediate-ca.csr

  common_name          = "evelyn.internal Intermediate CA"
  exclude_cn_from_sans = true
  ou                   = "Evelyn"
  organization         = "EphyraSoftware"
  ttl                  = "43800h" # 5 years
}

resource "vault_pki_secret_backend_intermediate_set_signed" "intermediate-ca" {
  backend = vault_mount.intermediate-ca.path

  certificate = vault_pki_secret_backend_root_sign_intermediate.intermediate-ca.certificate
}
