resource "kubernetes_namespace" "evelyn-platform" {
  metadata {
    name = var.namespace
  }
}
