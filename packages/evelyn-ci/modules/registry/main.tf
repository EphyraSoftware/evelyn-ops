locals {
  admin-username = "admin"
}

resource "vault_pki_secret_backend_cert" "registry" {
  backend = "pki_intermediate"
  name    = "evelyn-internal-role"

  auto_renew = true
  ttl        = "720h"
  format     = "pem"

  common_name = var.hostname
}

resource "kubernetes_secret" "registry-ca" {
  metadata {
    name      = "registry-ca"
    namespace = var.namespace
  }

  data = {
    "ca.crt" = vault_pki_secret_backend_cert.registry.ca_chain
  }

  type = "Opaque"
}

resource "kubernetes_secret" "registry-tls" {
  metadata {
    name      = "registry-tls"
    namespace = var.namespace
  }

  data = {
    "tls.crt" = vault_pki_secret_backend_cert.registry.certificate
    "tls.key" = vault_pki_secret_backend_cert.registry.private_key
  }

  type = "kubernetes.io/tls"
}

resource "kubernetes_secret" "registry-auth" {
  metadata {
    name      = "registry-auth"
    namespace = var.namespace
  }

  data = {
    "pass.txt" = random_password.admin_password.result
  }
}

resource "random_password" "admin_password" {
  length  = 10
  special = false
}

resource "kubernetes_deployment" "registry" {
  metadata {
    name      = "registry"
    namespace = var.namespace

    labels = {
      "app" = "registry"
    }
  }
  spec {
    selector {
      match_labels = {
        "app" = "registry"
      }
    }

    replicas = 1

    template {
      metadata {
        name = "registry"

        labels = {
          "app" = "registry"
        }
      }
      spec {
        init_container {
          name  = "update-certificates"
          image = "registry:2.7.0"

          command = [
            "/bin/sh", "-c",
            "cp /tmp/ca/ca.crt /usr/local/share/ca-certificates/ && update-ca-certificates && cp -a /etc/ssl/certs/ /tmp/certs"
          ]

          volume_mount {
            mount_path = "/tmp/ca"
            name       = "ca"
          }

          volume_mount {
            mount_path = "/tmp/certs"
            name       = "ca-certs"
          }
        }

        init_container {
          name  = "create-user"
          image = "registry:2.7.0" # TODO https://github.com/docker/docker.github.io/issues/11060

          command = [
            "/bin/sh", "-c",
            "cat /tmp/auth/pass.txt | htpasswd -Bin ${local.admin-username} > /etc/auth/htpasswd"
          ]

          volume_mount {
            mount_path = "/tmp/auth"
            name       = "registry-auth"
          }

          volume_mount {
            mount_path = "/etc/auth"
            name       = "registry-htpasswd"
          }
        }

        container {
          name  = "registry"
          image = "registry:2.7.0"

          port {
            name           = "https"
            container_port = 5000
          }

          env {
            name  = "REGISTRY_HTTP_ADDR"
            value = "0.0.0.0:5000"
          }

          env {
            name  = "REGISTRY_HTTP_TLS_CERTIFICATE"
            value = "/certs/tls.crt"
          }

          env {
            name  = "REGISTRY_HTTP_TLS_KEY"
            value = "/certs/tls.key"
          }

          env {
            name  = "REGISTRY_AUTH"
            value = "htpasswd"
          }

          env {
            name  = "REGISTRY_AUTH_HTPASSWD_REALM"
            value = "Registry Realm"
          }

          env {
            name  = "REGISTRY_AUTH_HTPASSWD_PATH"
            value = "/etc/auth/htpasswd"
          }

          env {
            name  = "REGISTRY_LOG_LEVEL"
            value = "debug"
          }

          volume_mount {
            mount_path = "/var/lib/registry"
            name       = "registry-storage"
          }

          volume_mount {
            mount_path = "/certs"
            name       = "tls"
          }

          volume_mount {
            mount_path = "/etc/ssl/certs/"
            name       = "ca-certs"
          }

          volume_mount {
            mount_path = "/etc/auth"
            name       = "registry-htpasswd"
          }
        }

        volume {
          name = "registry-storage"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.registry_storage.metadata.0.name
          }
        }

        volume {
          name = "tls"
          secret {
            secret_name = kubernetes_secret.registry-tls.metadata.0.name
          }
        }

        volume {
          name = "ca"
          secret {
            secret_name = kubernetes_secret.registry-ca.metadata.0.name
          }
        }

        volume {
          name = "ca-certs"
          empty_dir {}
        }

        volume {
          name = "registry-auth"
          secret {
            secret_name = kubernetes_secret.registry-auth.metadata.0.name
          }
        }

        volume {
          name = "registry-htpasswd"
          empty_dir {}
        }
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "registry_storage" {
  metadata {
    name      = "registry-storage"
    namespace = var.namespace

    labels = {
      "app" = "registry"
    }
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "15Gi"
      }
      limits = {
        storage = "15Gi"
      }
    }
  }
}

resource "kubernetes_service" "registry" {
  metadata {
    name      = "registry"
    namespace = var.namespace

    labels = {
      "app" = "registry"
    }
  }
  spec {
    type = "ClusterIP"

    selector = {
      "app" = "registry"
    }

    port {
      name = "https"
      port = 5000
    }
  }
}

resource "k8s-yaml_raw" "ingress" {
  name = "ingress"

  files = [
    "${path.module}/ingress-route.yaml"
  ]
}
