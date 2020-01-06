locals {
  service_name = "evelyn-email-service"
}

resource "kubernetes_deployment" "email-service" {
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
              name = kubernetes_config_map.email-service-config.metadata[0].name
            }
          }
        }
        image_pull_secrets {
          name = var.image_pull_secret
        }
      }
    }
  }
}

resource "kubernetes_config_map" "email-service-config" {
  metadata {
    name = "${local.service_name}-config"
    namespace = var.namespace
  }

  data = {
    SPRING_PROFILES_ACTIVE = join(",", var.spring_profiles_active)
    RABBITMQ_HOST = var.rabbitmq_host
    RABBITMQ_PORT = var.rabbitmq_port
    MAIL_HOST = var.mail_host
    MAIL_PORT = var.mail_port
    MAIL_USERNAME = var.mail_username
    MAIL_PASSWORD = var.mail_password
    MAIL_SMTP_HOST = var.mail_smtp_host
  }
}
