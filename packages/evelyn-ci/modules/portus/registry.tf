resource "kubernetes_deployment" "registry" {
  metadata {
    name = "registry"
    namespace = var.namespace

    labels = {
      "app" = "registry"
    }
  }
  spec {
    selector {
      match_labels = {
        "app" = "registry"
      }
    }

    template {
      metadata {
        name = "registry"

        labels = {
          "app" = "registry"
        }
      }
      spec {
        container {
          name = "registry"
          image = "library/registry:2.6"

          command = ["/bin/sh", "/etc/docker/registry/init.sh"]

          port {
            container_port = 5000
          }

          # required to access debug service
          port {
            container_port = 5001
          }

          env_from {
            config_map_ref {
              name = kubernetes_config_map.registry-config.metadata.0.name
            }
          }

          volume_mount {
            mount_path = "/secrets"
            name = "tls-secrets"
            read_only = true
          }

          volume_mount {
            mount_path = "/ca"
            name = "ca-bundle"
            read_only = true
          }

          volume_mount {
            mount_path = "/etc/docker/registry/"
            name = "config-files"
          }

          volume_mount {
            mount_path = "/var/lib/registry"
            name = "registry"
          }
        }

        volume {
          name = "tls-secrets"
          secret {
             secret_name = kubernetes_secret.portus-tls.metadata.0.name
          }
        }

        volume {
          name = "ca-bundle"
          secret {
            secret_name = kubernetes_secret.ca-bundle.metadata.0.name
          }
        }

        volume {
          name = "config-files"
          config_map {
            name = kubernetes_config_map.registry-config-files.metadata.0.name
            default_mode = "0744"
          }
        }

        volume {
          name = "registry"
          persistent_volume_claim {
             claim_name = kubernetes_persistent_volume_claim.registry.metadata.0.name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "registry" {
  metadata {
    name = "registry"
    namespace = var.namespace
  }
  spec {
    type = "ClusterIP"

    port {
      port = 5000
    }

    selector = {
      "app" = "registry"
    }
  }
}

resource "kubernetes_config_map" "registry-config" {
  metadata {
    name = "registry-config"
    namespace = var.namespace
  }

  data = {
    # Authentication
    REGISTRY_AUTH_TOKEN_REALM = "https://${var.hostname}/v2/token"
    REGISTRY_AUTH_TOKEN_SERVICE: var.hostname
    REGISTRY_AUTH_TOKEN_ISSUER: var.hostname

    REGISTRY_AUTH_TOKEN_ROOTCERTBUNDLE = "/ca/ca-bundle.crt"

    # SSL
    REGISTRY_HTTP_TLS_CERTIFICATE = "/secrets/tls.crt"
    REGISTRY_HTTP_TLS_KEY = "/secrets/tls.key"

    # Portus endpoint
    REGISTRY_NOTIFICATIONS_ENDPOINTS = <<EOF
- name: portus
  url: https://${var.hostname}/v2/webhooks/events
  timeout: 2000ms
  threshold: 5
  backoff: 1s
EOF
  }
}

resource "kubernetes_config_map" "registry-config-files" {
  metadata {
    name = "registry-config-files"
    namespace = var.namespace
  }

  data = {
    "config.yml" = file("${path.module}/registry/config.yml")
    "init.sh" = file("${path.module}/registry/init.sh")
  }
}

resource "kubernetes_secret" "ca-bundle" {
  metadata {
    name = "ca-bundle"
    namespace = var.namespace
  }
  data = {
    "ca-bundle.crt" = "${vault_pki_secret_backend_cert.portus.ca_chain}\n${vault_pki_secret_backend_cert.portus.certificate}"
  }
}

resource "kubernetes_persistent_volume_claim" "registry" {
  metadata {
    name = "registry"
    namespace = var.namespace
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    storage_class_name = var.storage_class_name
    resources {
      requests = {
        storage = "25Gi"
      }
    }
  }
}
