resource "kubernetes_ingress" "evelyn-services" {
  metadata {
    name = "evelyn-services"
    namespace = var.namespace
  }
  spec {
    rule {
      http {
        path {
          path = "/tasks"
          backend {
            service_name = var.tasks_service_name
            service_port = var.tasks_service_port
          }
        }
      }
    }
    tls {

    }
  }
}