locals {
  service_name = "evelyn-group-service"
}

resource "kubernetes_deployment" "group-service" {
  metadata {
    name = local.service_name
    namespace = var.namespace

    labels = {
      app = local.service_name
    }
  }
  spec {
    replicas = 1

    selector {
      match_labels = {
        app = local.service_name
      }
    }

    template {
      metadata {
        labels = {
          app = local.service_name
        }
      }
      spec {
        container {
          name = local.service_name
          image_pull_policy = var.image_pull_policy
          image = var.image

          env_from {
            config_map_ref {
              name = kubernetes_config_map.group-service-config.metadata[0].name
            }
          }

          port {
            name = "http"
            container_port = 8080
          }

          volume_mount {
            name = "keystore"
            mount_path = "/etc/evelyn"
            read_only = true
          }
        }

        image_pull_secrets {
          name = var.image_pull_secret
        }

        volume {
          name = "keystore"
          secret {
            secret_name = var.group_service_keystore_secret_name
          }
        }
      }
    }
  }
}

resource "kubernetes_config_map" "group-service-config" {
  metadata {
    name = "${local.service_name}-config"
    namespace = var.namespace
  }

  data = {
    SPRING_PROFILES_ACTIVE = join(",", var.spring_profiles_active)
    MONGO_CONNECTION_URI = var.mongo_connection_uri
    KEYCLOAK_AUTH_URL = var.keycloak_auth_url
    PROFILE_SERVICE_BASE_URL = var.profile_service_base_url
  }
}

resource "kubernetes_service" "group-service" {
  metadata {
    name = local.service_name
    namespace = var.namespace

    labels = {
      app = local.service_name
    }
  }

  spec {
    type = "ClusterIP"

    port {
      name = "http"
      port = 8080
    }

    selector = {
      app = local.service_name
    }
  }
}
