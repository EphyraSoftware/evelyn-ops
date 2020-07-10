resource "helm_release" "elastic-search" {
  name       = "elastic-search"
  namespace  = var.namespace
  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"
  version    = "7.7.1"

  timeout = 900

  values = [
    file("${path.module}/files/values.yaml")
  ]
}
