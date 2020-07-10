resource "kubernetes_deployment" "portus-backend" {
  metadata {
    name      = "portus-backend"
    namespace = var.namespace

    labels = {
      app = "portus-backend"
    }
  }
  spec {
    selector {
      match_labels = {
        app = "portus-backend"
      }
    }

    template {
      metadata {
        name = "portus-backend"

        labels = {
          app = "portus-backend"
        }
      }
      spec {
        container {
          name              = "portus-backend"
          image             = "opensuse/portus:head"
          image_pull_policy = "IfNotPresent"

          command = ["/bin/sh", "/init"]

          env {
            name  = "CCONFIG_PREFIX"
            value = "PORTUS"
          }

          env {
            name  = "PORTUS_BACKGROUND"
            value = "true"
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
            name       = "certificates"
            mount_path = "/certificates"
            read_only  = true
          }
        }

        volume {
          name = "certificates"
          secret {
            secret_name = kubernetes_secret.portus-tls.metadata.0.name
          }
        }
      }
    }
  }
}
