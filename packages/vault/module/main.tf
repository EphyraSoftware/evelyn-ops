resource "kubernetes_namespace" "vault" {
  metadata {
    name = "vault"
  }
}

resource "helm_release" "vault" {
  namespace  = kubernetes_namespace.vault.metadata.0.name
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  name       = "vault"
  version    = "0.6.0"

  values = [
    file("${path.module}/files/values.yaml")
  ]

  set {
    name  = "server.ingress.hosts[0].host"
    value = var.hostname
  }

  set {
    name  = "server.ingress.tls[0].secretName"
    value = kubernetes_secret.vault-tls.metadata.0.name
  }

  set {
    name  = "server.ingress.tls[0].hosts[0]"
    value = var.hostname
  }
}
