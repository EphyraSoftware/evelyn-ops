resource "kubernetes_deployment" "portus" {
  metadata {
    name = "portus"
    namespace = var.namespace

    labels = {
      "app" = "portus"
    }
  }
  spec {
    selector {
      match_labels = {
        "app" = "portus"
      }
    }

    template {
      metadata {
        name = "portus"

        labels = {
          "app" = "portus"
        }
      }
      spec {
        init_container {
          name = "copy-static-content"
          image = "opensuse/portus:head"

          command = ["/bin/sh", "-c", "cp -a /srv/Portus/public/. /tmp/portus-static-content/"]

          volume_mount {
            mount_path = "/tmp/portus-static-content"
            name = "portus-static-content"
          }
        }

        init_container {
          name = "update-trust"
          image = "opensuse/portus:head"

          command = ["/bin/sh", "-c", "cp /ca/portus-ca-bundle.crt /usr/local/share/ca-certificates && update-ca-certificates && cp -a /etc/ssl/certs/. /tmp"]

          volume_mount {
            mount_path = "/ca"
            name = "portus-ca-bundle"
          }

          volume_mount {
            mount_path = "/tmp"
            name = "certs"
          }
        }

        container {
          name = "portus"
          image = "opensuse/portus:head"
          image_pull_policy = "IfNotPresent"

          command = ["/bin/sh", "/init"]

          port {
            container_port = 3000
          }

          env_from {
            config_map_ref {
              name = kubernetes_config_map.portus-config.metadata.0.name
            }
          }

          env_from {
            secret_ref {
              name = kubernetes_secret.portus-config.metadata.0.name
            }
          }

          volume_mount {
            name = "certificates"
            mount_path = "/certificates"
            read_only = true
          }

          volume_mount {
            mount_path = "/srv/Portus/public"
            name = "portus-static-content"
          }

          volume_mount {
            mount_path = "/etc/ssl/certs/"
            name = "certs"
          }
        }

        volume {
          name = "certificates"
          secret {
            secret_name = kubernetes_secret.portus-tls.metadata.0.name
          }
        }

        volume {
          name = "portus-static-content"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.portus-static-content.metadata.0.name
          }
        }

        volume {
          name = "portus-ca-bundle"
          secret {
            secret_name = kubernetes_secret.portus-ca-bundle.metadata.0.name
          }
        }

        volume {
          name = "certs"
          empty_dir {}
        }
      }
    }
  }
}

resource "kubernetes_service" "portus" {
  metadata {
    name = "portus"
    namespace = var.namespace
  }
  spec {
    type = "ClusterIP"

    selector = {
      "app" = "portus"
    }

    port {
      port = 3000
    }
  }
}

resource "kubernetes_secret" "portus-ca-bundle" {
  metadata {
    name = "portus-ca-bundle"
    namespace = var.namespace
  }
  data = {
    "portus-ca-bundle.crt" = vault_pki_secret_backend_cert.portus.ca_chain
  }
}

resource "kubernetes_persistent_volume_claim" "portus-static-content" {
  metadata {
    name = "portus-static-content"
    namespace = var.namespace
  }
  spec {
    access_modes = ["ReadWriteMany"]
    storage_class_name = var.shared_storage_class_name
    resources {
      requests = {
        storage = "5Gi"
      }
    }
  }
}
