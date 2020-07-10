resource "helm_release" "kibana" {
  name       = "kibana"
  namespace  = var.namespace
  repository = "https://helm.elastic.co"
  chart      = "kibana"
  version    = "7.7.1"

  timeout = 900

  values = [
    file("${path.module}/files/values.yaml")
  ]
}
