resource "kubernetes_namespace" "vault" {
  metadata {
    name = "vault"
  }
}

resource "helm_release" "vault" {
  namespace = kubernetes_namespace.vault.metadata.0.name
  repository = "https://helm.releases.hashicorp.com"
  chart = "vault"
  name = "vault"
  version = "0.6.0"

  values = [
    file("${path.module}/files/values.yaml")
  ]
}
