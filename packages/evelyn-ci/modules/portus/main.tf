locals {
  database_name = "portus"
}

resource "random_password" "db" {
  length = 20
  special = false
}

resource "random_password" "portus_password" {
  length = 25
  special = false
}

resource "kubernetes_config_map" "portus-config" {
  metadata {
    name      = "portus-config"
    namespace = var.namespace
  }

  data = {
    PORTUS_MACHINE_FQDN_VALUE = var.hostname

    PORTUS_DB_HOST     = kubernetes_service.portus-db.metadata.0.name
    PORTUS_DB_DATABASE = local.database_name
    PORTUS_DB_PASSWORD = random_password.db.result
    PORTUS_DB_POOL     = "5"

    PORTUS_PUMA_TLS_KEY  = "/certificates/tls.key"
    PORTUS_PUMA_TLS_CERT = "/certificates/tls.crt"
  }
}

resource "kubernetes_secret" "portus-config" {
  metadata {
    name      = "portus-config"
    namespace = var.namespace
  }

  data = {
    PORTUS_SECRET_KEY_BASE = file("${path.module}/secrets/keybase.secret.txt")
    PORTUS_KEY_PATH        = "/certificates/tls.key"
    PORTUS_PASSWORD        = random_password.portus_password.result
  }
}

