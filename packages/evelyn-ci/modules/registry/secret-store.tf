resource "vault_generic_secret" "registry-credentials" {
  path = "evelyn-ops/registry-credentials"

  data_json = <<EOT
{
  "username": "${local.admin-username}",
  "password": "${random_password.admin_password.result}"
}
EOT
}
