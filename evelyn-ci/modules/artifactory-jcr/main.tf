data "helm_repository" "jfrog" {
  name = "jfrog"
  url  = "https://charts.jfrog.io"
}

resource "helm_release" "artifactory" {
  # 15 minutes.
  timeout = "900"

  name       = "artifactory-jcr"
  repository = data.helm_repository.jfrog.metadata[0].name
  chart      = "jfrog/artifactory-jcr"
  version    = "1.1.1"
  namespace = var.namespace

  values = [
    file("${path.module}/files/values.yaml")
  ]
}
