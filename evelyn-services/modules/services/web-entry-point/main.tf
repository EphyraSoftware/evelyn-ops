locals {
  service_name = "evelyn-web-entry-point"
}

resource "kubernetes_deployment" "web-entry-point" {
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
              name = kubernetes_config_map.web-entry-point-config.metadata[0].name
            }
          }

          port {
            name = "http"
            container_port = 5000
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
          config_map {
            name = var.web_entry_point_keystore_config_map_name
          }
        }
      }
    }
  }
}

resource "kubernetes_config_map" "web-entry-point-config" {
  metadata {
    name = "${local.service_name}-config"
    namespace = var.namespace
  }

  data = {
    SPRING_PROFILES_ACTIVE = join(",", var.spring_profiles_active)
    PROFILE_SERVICE_HOST = var.profile_service_host
    GROUP_SERVICE_HOST = var.group_service_host
    TASK_SERVICE_HOST = var.task_service_host
    CALENDAR_SERVICE_HOST = var.calendar_service_host
  }
}

resource "kubernetes_service" "web-entry-point" {
  metadata {
    name = local.service_name
    namespace = var.namespace

    labels = {
      app = local.service_name
    }
  }

  spec {
    type = "NodePort"

    port {
      name = "http"
      port = 5000
      node_port = 30021
    }

    selector = {
      app = local.service_name
    }
  }
}
