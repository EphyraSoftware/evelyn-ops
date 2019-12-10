data "vault_policy_document" "ca-provisioner" {
  rule {
    path         = "sys/mounts/*"
    capabilities = [ "create", "read", "update", "delete", "list" ]
    description  = "Enable secrets engine"
  }

  rule {
    path         = "sys/mounts"
    capabilities = [ "read", "list" ]
    description  = "List enabled secrets engine"
  }

  rule {
    path         = "pki*"
    capabilities = [ "create", "read", "update", "delete", "list", "sudo" ]
    description  = "Work with pki secrets engine"
  }

  rule {
    path = "auth/token/create"
    capabilities = ["create", "read", "update", "list"]
  }
}

resource "vault_policy" "ca-provisioner" {
  name   = "ca-provisioner"
  policy = data.vault_policy_document.ca-provisioner.hcl
}
