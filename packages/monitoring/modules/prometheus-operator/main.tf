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
    value = var.storage_class_name
  }

  set {
    name = "grafana.ingress.hosts[0]"
    value = var.grafana_hostname
  }

  set {
    name = "grafana.ingress.tls[0].secretName"
    value = kubernetes_secret.grafana-tls.metadata.0.name
  }

  set {
    name = "grafana.ingress.tls[0].hosts[0]"
    value = var.grafana_hostname
  }
}
