resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = "nginx"
    namespace = var.namespace

    labels = {
      "app" = "nginx"
    }
  }
  spec {
    selector {
      match_labels = {
        "app" = "nginx"
      }
    }
    template {
      metadata {
        name = "nginx"

        labels = {
          "app" = "nginx"
        }
      }
      spec {
        container {
          name  = "nginx"
          image = "nginx:alpine"

          port {
            container_port = 443
          }

          volume_mount {
            name       = "certificates"
            mount_path = "/certificates"
            read_only  = true
          }

          volume_mount {
            mount_path = "/srv/Portus/public"
            name       = "portus-static-content"
          }

          volume_mount {
            mount_path = "/etc/nginx/nginx.conf"
            name       = "nginx-conf"
            sub_path   = "nginx.conf"
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
          name = "nginx-conf"
          config_map {
            name = kubernetes_config_map.nginx-conf.metadata.0.name
          }
        }
      }
    }
  }
}

resource "kubernetes_config_map" "nginx-conf" {
  metadata {
    name      = "nginx-conf"
    namespace = var.namespace
  }

  data = {
    "nginx.conf" = file("${path.module}/nginx/nginx.conf")
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name      = "nginx"
    namespace = var.namespace
  }
  spec {
    type = "ClusterIP"

    port {
      port = 443
    }

    selector = {
      "app" = "nginx"
    }
  }
}
