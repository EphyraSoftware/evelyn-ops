resource "kubernetes_namespace" "traefik" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "traefik" {
  chart      = "traefik"
  name       = "traefik"
  namespace  = kubernetes_namespace.traefik.metadata.0.name
  repository = "https://containous.github.io/traefik-helm-chart"
  version    = "8.8.1"

  // The chart installs correctly but something the Terraform provider for Helm does prevents the installation from
  // completing correctly. Appears hooks do not finish running when Terraform is involved?
  wait = false

  values = [
    file("${path.module}/files/values.yaml")
  ]

  set {
    name  = "volumes[0].name"
    value = kubernetes_secret.traefik-tls.metadata.0.name
  }

  set {
    name  = "volumes[1].name"
    value = kubernetes_config_map.traefik-config.metadata.0.name
  }

  set {
    name  = "volumes[2].name"
    value = kubernetes_config_map.ca-certs.metadata.0.name
  }
}

resource "kubernetes_config_map" "ca-certs" {
  metadata {
    name      = "ca-certs"
    namespace = kubernetes_namespace.traefik.metadata.0.name
  }

  data = {
    "ca.crt" = "${var.certificate_authority_root}\n${var.certificate_authority_int}",
  }
}

resource "kubernetes_config_map" "traefik-config" {
  metadata {
    name      = "traefik-config"
    namespace = kubernetes_namespace.traefik.metadata.0.name
  }

  data = {
    "dynamic.toml" = <<EOF
[[tls.certificates]]
  certFile = "/certs/tls.crt"
  keyFile = "/certs/tls.key"
EOF
  }
}
