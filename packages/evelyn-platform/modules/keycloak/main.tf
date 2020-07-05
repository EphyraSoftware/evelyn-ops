# helm repo add codecentric https://codecentric.github.io/helm-charts
resource "helm_release" "keycloak" {
  chart = "keycloak"
  name = "keycloak"
  repository = "https://codecentric.github.io/helm-charts"
  version = "8.2.2"
  namespace = var.namespace

  values = [
    file("${path.module}/files/values.yaml")
  ]

  set {
    name = "keycloak.existingSecret"
    value = kubernetes_secret.admin.metadata.0.name
  }

  set {
    name = "keycloak.ingress.hosts[0]"
    value = var.keycloak_hostname
  }

  set {
    name = "keycloak.ingress.tls[0].secretName"
    value = kubernetes_secret.keycloak-tls.metadata.0.name
  }

  set {
    name = "keycloak.ingress.tls[0].hosts[0]"
    value = var.keycloak_hostname
  }
}

resource "kubernetes_secret" "admin" {
  metadata {
    name = "keycloak-admin"
    namespace = var.namespace
  }

  data = {
    "password" = random_password.admin-password.result
  }
}

resource "random_password" "admin-password" {
  length = 24
  special = false
}
