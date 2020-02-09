resource "kubernetes_namespace" "evelyn-ci" {
  metadata {
    name = "evelyn-ci"
  }
}