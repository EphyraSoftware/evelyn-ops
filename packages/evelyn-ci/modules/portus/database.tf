resource "kubernetes_deployment" "portus-db" {
  metadata {
    name      = "portus-db"
    namespace = var.namespace

    labels = {
      app = "portus-db"
    }
  }
  spec {
    selector {
      match_labels = {
        app = "portus-db"
      }
    }
    template {
      metadata {
        name = "portus-db"

        labels = {
          app = "portus-db"
        }
      }
      spec {
        container {
          name  = "portus-db"
          image = "library/mariadb:10.0.23"

          args = ["--character-set-server=utf8", "--collation-server=utf8_unicode_ci", "--init-connect='SET NAMES UTF8;'", "--innodb-flush-log-at-trx-commit=0"]

          env {
            name  = "MYSQL_DATABASE"
            value = local.database_name
          }

          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = random_password.db.result
          }

          volume_mount {
            mount_path = "/var/lib/mysql"
            name       = "portus-db-storage"
          }

          port {
            container_port = 3306
          }
        }

        volume {
          name = "portus-db-storage"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.portus-db.metadata.0.name
          }
        }
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "portus-db" {
  metadata {
    name      = "portus-db-storage"
    namespace = var.namespace
  }
  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = var.storage_class_name
    resources {
      requests = {
        storage = "5Gi"
      }
    }
  }
}

resource "kubernetes_service" "portus-db" {
  metadata {
    name      = "portus-db"
    namespace = var.namespace
  }
  spec {
    type = "ClusterIP"

    selector = {
      app = "portus-db"
    }

    port {
      port = 3306
    }
  }
}
