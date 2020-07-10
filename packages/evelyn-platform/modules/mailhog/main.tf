resource "helm_release" "mailhog" {
  repository = "https://codecentric.github.io/helm-charts"
  chart = "mailhog"
  version = "3.2.0"
  name = "mailhog"
  namespace = var.namespace

  values = [
    file("${path.module}/files/values.yaml")
  ]

  set {
    name = "ingress.hosts[0].host"
    value = var.hostname
  }

  set {
    name = "ingress.tls[0].secretName"
    value = kubernetes_secret.mailhog-tls.metadata.0.name
  }

  set {
    name = "ingress.tls[0].hosts[0]"
    value = var.hostname
  }
}
