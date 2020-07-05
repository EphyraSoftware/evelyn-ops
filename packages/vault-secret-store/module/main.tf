resource "vault_mount" "evelyn-ops" {
  path        = "evelyn-ops"
  type        = "generic"
  description = "Mount for storing secrets to share between Evelyn operations packages"
}
