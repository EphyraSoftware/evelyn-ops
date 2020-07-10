locals {
  rabbitmq_username = "evelyn_rabbit_user"
}

resource "helm_release" "rabbitmq" {
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "rabbitmq"
  version    = "7.5.1"

  name      = "rabbitmq"
  namespace = var.namespace

  values = [
    file("${path.module}/files/values.yaml")
  ]

  set {
    name  = "auth.username"
    value = local.rabbitmq_username
  }

  set {
    name  = "auth.password"
    value = random_password.rabbitmq-password.result
  }

  set {
    name  = "ingress.hostname"
    value = var.rabbitmq_hostname
  }

  set {
    name  = "ingress.existingSecret"
    value = kubernetes_secret.rabbitmq-tls.metadata.0.name
  }
}

resource "random_password" "rabbitmq-password" {
  length  = 22
  special = false
}