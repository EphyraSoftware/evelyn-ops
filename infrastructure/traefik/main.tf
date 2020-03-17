data "helm_repository" "traefik" {
  name = "traefik"
  url = "https://containous.github.io/traefik-helm-chart"
}

resource "helm_release" "traefik" {
  chart = "traefik/traefik"
  name = "traefik"
  namespace = var.namespace

  values = [
    file("${path.module}/files/values.yaml")
  ]
}

resource "kubernetes_config_map" "traefik-config" {
  metadata {
    name = "traefik-config"
    namespace = var.namespace
  }

  data = {
    "dynamic.toml" = <<EOF
[[tls.certificates]]
  certFile = "/certs/tls.crt"
  keyFile = "/certs/tls.key"

[providers.kubernetesCRD]
  ingressClass = "traefik"

[api]
  dashboard = true
  insecure = true
EOF
  }
}
