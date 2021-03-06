resource "kubernetes_ingress" "evelyn-services" {
  metadata {
    name      = "evelyn-services"
    namespace = var.namespace

    annotations = {
      "traefik.ingress.kubernetes.io/frontend-entry-points" = "websecure"
      "traefik.ingress.kubernetes.io/router.tls"            = "true"
    }
  }
  spec {
    rule {
      host = var.external_shared_hostname
      http {
        path {
          path = "/tasks"
          backend {
            service_name = var.task_service_name
            service_port = var.task_service_port
          }
        }
      }
    }
    rule {
      host = var.external_shared_hostname
      http {
        path {
          path = "/profiles"
          backend {
            service_name = var.profile_service_name
            service_port = var.profile_service_port
          }
        }
      }
    }
    rule {
      host = var.external_shared_hostname
      http {
        path {
          path = "/groups"
          backend {
            service_name = var.group_service_name
            service_port = var.group_service_port
          }
        }
      }
    }
    rule {
      host = var.external_shared_hostname
      http {
        path {
          path = "/todos"
          backend {
            service_name = var.todo_service_name
            service_port = var.todo_service_port
          }
        }
      }
    }
    rule {
      host = var.external_shared_hostname
      http {
        path {
          path = "/calendars"
          backend {
            service_name = var.calendar_service_name
            service_port = var.calendar_service_port
          }
        }
      }
    }
    tls {
      hosts       = [var.external_shared_hostname]
      secret_name = kubernetes_secret.ingress-tls.metadata.0.name
    }
  }
}

resource "vault_pki_secret_backend_cert" "ingress" {
  backend = "pki_intermediate"
  name    = "evelyn-internal-role"

  auto_renew = true
  ttl        = "720h"

  format = "pem"

  common_name = var.external_shared_hostname
}

resource "kubernetes_secret" "ingress-tls" {
  metadata {
    name      = "ingress-tls"
    namespace = var.namespace
  }

  data = {
    "tls.crt" = vault_pki_secret_backend_cert.ingress.certificate
    "tls.key" = vault_pki_secret_backend_cert.ingress.private_key
  }
}
