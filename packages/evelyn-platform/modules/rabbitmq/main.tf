resource "helm_release" "rabbitmq" {
  chart = "rabbitmq-ha"
  name = "rabbitmq-ha"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  version = "1.46.4"
  namespace = var.namespace

  values = [
    file("${path.module}/files/values.yaml")
  ]
}

data "kubernetes_secret" "rabbitmq-ha" {
  metadata {
    name = helm_release.rabbitmq.name
    namespace = var.namespace
  }
}
