output "namespace" {
  value = kubernetes_namespace.evelyn-ci.metadata.0.name
}
