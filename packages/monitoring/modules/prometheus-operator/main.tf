resource "helm_release" "prometheus-operator" {
  name = "prometheus-operator"
  namespace = var.namespace
  chart = "prometheus-operator"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  version = "8.14.0"

  values = [
    file("${path.module}/files/values.yaml")
  ]

  set {
    name = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.storageClassName"
    value = var.storage-class-name
  }
}
