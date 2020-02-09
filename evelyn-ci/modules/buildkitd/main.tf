locals {
  name = "buildkitd"
}

# Adapted from https://github.com/moby/buildkit/blob/master/examples/kubernetes/deployment%2Bservice.rootless.yaml
resource "kubernetes_deployment" "buildkitd" {
  metadata {
    labels = {
      app = local.name
    }

    name = local.name
    namespace = var.namespace
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = local.name
      }
    }

    template {
      metadata {
        labels = {
          app = local.name
        }

        annotations = {
          "container.apparmor.security.beta.kubernetes.io/buildkitd" = "unconfined"
          "container.seccomp.security.alpha.kubernetes.io/buildkitd" = "unconfined"
        }
      }

      spec {
        init_container {
          name = "add-ca"
          image = "alpine:latest"
          command = [
            "sh", "-c",
            "apk add --update ca-certificates && cp /certs/ca.pem /usr/local/share/ca-certificates && update-ca-certificates && cp /etc/ssl/certs/* /tmp/"
          ]

          volume_mount {
            mount_path = "/tmp"
            name = "trusted-certs"
          }

          volume_mount {
            mount_path = "/certs"
            name = "certs"
            read_only = true
          }
        }

        container {
          name = local.name
          image = "moby/buildkit:${var.image_tag}"

          args = [
            "--addr", "unix:///run/user/1000/buildkit/buildkitd.sock",
            "--addr", "tcp://0.0.0.0:${var.port}",
            "--tlscacert", "/certs/ca.pem",
            "--tlscert", "/certs/cert.pem",
            "--tlskey", "/certs/key.pem",
            "--oci-worker-no-process-sandbox"
          ]

          readiness_probe {
            exec {
              command = [
                "buildctl",
                "debug",
                "workers"
              ]
            }

            initial_delay_seconds = 5
            period_seconds = 30
          }

          liveness_probe {
            exec {
              command = [
                "buildctl",
                "debug",
                "workers"
              ]
            }

            initial_delay_seconds = 5
            period_seconds = 30
          }

          security_context {
            run_as_user = 1000
            run_as_group = 1000
          }

          port {
            container_port = var.port
          }

          volume_mount {
            mount_path = "/certs"
            name = "certs"
            read_only = true
          }

          volume_mount {
            mount_path = "/etc/ssl/certs"
            name = "trusted-certs"
          }
        }

        volume {
          name = "certs"
          secret {
            secret_name = kubernetes_secret.certs.metadata.0.name
          }
        }

        volume {
          name = "trusted-certs"
          empty_dir {}
        }
      }
    }
  }
}

resource "kubernetes_service" "buildkitd" {
  metadata {
    labels = {
      app = local.name
    }

    name = local.name
    namespace = var.namespace
  }
  spec {
    port {
      port = var.port
      protocol = "TCP"
    }

    selector = {
      app = local.name
    }
  }
}

resource "kubernetes_service" "buildkitd-node" {
  count = var.expose_node_port ? 1 : 0
  metadata {
    labels = {
      app = local.name
    }

    name = "${local.name}-node"
    namespace = var.namespace
  }
  spec {
    type = "NodePort"

    port {
      port = var.port
      node_port = var.node_port
      protocol = "TCP"
    }

    selector = {
      app = local.name
    }
  }
}

resource "kubernetes_secret" "certs" {
  metadata {
    name = "${local.name}-certs"
    namespace = var.namespace
  }

  data = {
    "ca.pem" = file("\\\\nas.evelyn.internal\\terraform\\.files\\ca-bundle.pem"),
    "cert.pem" = vault_pki_secret_backend_cert.buildkitd-server.certificate,
    "key.pem" = vault_pki_secret_backend_cert.buildkitd-server.private_key
  }
}
