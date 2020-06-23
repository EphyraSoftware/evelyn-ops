resource "kubernetes_namespace" "evelyn-ci" {
  metadata {
    name = var.namespace
  }
}
