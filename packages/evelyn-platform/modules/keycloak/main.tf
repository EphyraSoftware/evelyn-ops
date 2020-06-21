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
