resource "helm_release" "mongodb-replicaset" {
  chart      = "mongodb-replicaset"
  name       = "mongodb-replicaset"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  version    = "3.16.0"
  namespace  = var.namespace

  values = [
    file("${path.module}/files/values.yaml")
  ]
}
