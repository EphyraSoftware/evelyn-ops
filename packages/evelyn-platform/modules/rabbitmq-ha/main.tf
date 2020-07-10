resource "helm_release" "rabbitmq" {
  chart      = "rabbitmq-ha"
  name       = "rabbitmq-ha"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  version    = "1.46.4"
  namespace  = var.namespace

  values = [
    file("${path.module}/files/values.yaml")
  ]

  set {
    name  = "ingress.tlsSecret"
    value = kubernetes_secret.rabbitmq-tls.metadata.0.name
  }

  set {
    name  = "ingress.hostName"
    value = var.rabbitmq_hostname
  }
}

data "kubernetes_secret" "rabbitmq-ha" {
  metadata {
    name      = helm_release.rabbitmq.name
    namespace = var.namespace
  }
}
