resource "vault_mount" "root-ca" {
  path        = "pki"
  type        = "pki"
  description = "Container for the root CA"

  default_lease_ttl_seconds = 315360000 # 10 years
  max_lease_ttl_seconds     = 315360000 # 10 years
}

resource "vault_pki_secret_backend_root_cert" "root-ca" {
  depends_on = [vault_mount.root-ca]

  backend = vault_mount.root-ca.path

  type                 = "internal"
  common_name          = "evelyn.internal Root CA"
  ttl                  = "315360000" # 10 years
  format               = "pem"
  private_key_format   = "der"
  key_type             = "rsa"
  key_bits             = 4096
  exclude_cn_from_sans = true
  ou                   = "Evelyn"
  organization         = "EphyraSoftware"
}

resource "vault_pki_secret_backend_config_urls" "config_urls" {
  depends_on = [vault_pki_secret_backend_root_cert.root-ca]

  backend                 = vault_mount.root-ca.path
  issuing_certificates    = ["https://${var.hostname}/v1/pki/ca"]
  crl_distribution_points = ["https://${var.hostname}/v1/pki/crl"]
}
