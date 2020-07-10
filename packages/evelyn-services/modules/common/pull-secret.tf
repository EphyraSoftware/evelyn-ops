data "vault_generic_secret" "registry-credentials" {
  path = "evelyn-ops/registry-credentials"
}

resource "kubernetes_secret" "evelyn-registry" {
  metadata {
    name      = "evelyn-registry"
    namespace = kubernetes_namespace.services-namespace.metadata.0.name
  }

  data = {
    ".dockerconfigjson" = jsonencode({
      "auths" : {
        (var.registry_hostname) : {
          email    = var.registry_email
          username = data.vault_generic_secret.registry-credentials.data["username"]
          password = data.vault_generic_secret.registry-credentials.data["password"]
          auth = base64encode(join(":", [
            data.vault_generic_secret.registry-credentials.data["username"],
            data.vault_generic_secret.registry-credentials.data["password"]
          ]))
        }
      }
    })
  }

  type = "kubernetes.io/dockerconfigjson"
}
