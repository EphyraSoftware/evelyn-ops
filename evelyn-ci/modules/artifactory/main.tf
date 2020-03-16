data "helm_repository" "jfrog" {
  name = "jfrog"
  url  = "https://charts.jfrog.io"
}

resource "random_password" "admin_password" {
  length = 16
  special = true
}

resource "vault_generic_secret" "admin_password" {
  path = "evelyn-ci/artifactory_admin_password"

  data_json = <<EOT
{
  "admin_password": "${random_password.admin_password.result}"
}
EOT
}

resource "helm_release" "artifactory" {
  # 15 minutes.
  timeout = "900"

  name       = "artifactory-oss"
  repository = data.helm_repository.jfrog.metadata[0].name
  chart      = "jfrog/artifactory-oss"
  version    = "1.1.1"
  namespace = var.namespace

  values = [
    file("${path.module}/files/values.yaml")
  ]

  set_sensitive {
    name = "artifactory.artifactory.accessAdmin.password"
    value = vault_generic_secret.admin_password.data["admin_password"]
  }
}

output "thing" {
  value = vault_generic_secret.admin_password.data["admin_password"]
}
