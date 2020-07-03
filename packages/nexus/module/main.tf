resource "kubernetes_namespace" "nexus" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "nexus" {
  name = "nexus"
  namespace = kubernetes_namespace.nexus.metadata.0.name

  repository = "https://oteemo.github.io/charts/"
  chart = "sonatype-nexus"
  version = "2.3.0"

  values = [
    file("${path.module}/files/values.yaml")
  ]

  set {
    name = "ingress.tls.secretName"
    value = kubernetes_secret.nexus-tls.metadata.0.name
  }

  set {
    name = "nexusProxy.env.nexusHttpHost"
    value = vault_pki_secret_backend_cert.nexus.common_name
  }
}
